/**************************************************************************************************             
											RECIPE SHARING
 **************************************************************************************************/

/* =====================================================================
    Database:   RecipeSharing

    Authors:    Gina Krynski

    Written:    April/May 2020

    Description: This database holds a collection of recipes.  
======================================================================== */

USE master;
GO

DROP DATABASE IF EXISTS RecipeSharing;
GO

CREATE DATABASE RecipeSharing;
GO

USE RecipeSharing;
GO

/**************************************************************************************************             
									        TABLES
 **************************************************************************************************/
CREATE TABLE RecipeTypes (
    recipeTypeId    INT             NOT NULL    PRIMARY KEY     IDENTITY,
    [description]   VARCHAR(200)    NOT NULL    DEFAULT('')
);
GO

CREATE TABLE Diets (
    dietId          INT             NOT NULL    PRIMARY KEY     IDENTITY,
    [description]   VARCHAR(200)    NOT NULL    DEFAULT('')
);
GO

CREATE TABLE DifficultyLevel (
    difficultyLevelId   INT             NOT NULL    PRIMARY KEY     IDENTITY,
    [description]       VARCHAR(200)    NOT NULL    DEFAULT('')
)
GO

CREATE TABLE Ingredients (
    ingredientId    INT             NOT NULL    PRIMARY KEY     IDENTITY,
    ingredientName  VARCHAR(50)     NOT NULL    DEFAULT(''),
    [description]   VARCHAR(200)    NOT NULL    DEFAULT('')
);
GO

CREATE TABLE Users (
    userId          INT             NOT NULL    PRIMARY KEY     IDENTITY, 
    userName        VARChar(100)    NOT NULL,
    fName           VARCHAR(50)     NOT NULL    DEFAULT(''),
    lName           VARCHAR(50)     NOT NULL    DEFAULT(''),
    userEmail       VARCHAR(200)    NOT NULL,
    userPassword    VARBINARY(64)   NOT NULL,
    gender          CHAR(1),
    isDeleted       bit             NOT NULL    DEFAULT(0)
);
GO

CREATE TABLE Recipes(
    recipeId            INT             NOT NULL    PRIMARY KEY     IDENTITY,
    recipeTypeId        INT             NOT NULL    FOREIGN KEY REFERENCES RecipeTypes(recipeTypeId),
    dietId              INT             NOT NULL    FOREIGN KEY REFERENCES Diets(dietId),
    difficultyLevelId   INT             NOT NULL    FOREIGN KEY REFERENCES DifficultyLevel(difficultyLevelId),
    ownerId             INT             NOT NULL    FOREIGN KEY REFERENCES Users(userId),
    recipeName          VARCHAR(50)     NOT NULL    DEFAULT(''),
    timeInMinutes       INT             NOT NULL
)
GO

CREATE TABLE RecipeIngredients (
    recipeId        INT             NOT NULL    FOREIGN KEY REFERENCES Recipes(recipeId),
    ingredientId    INT             NOT NULL    FOREIGN KEY REFERENCES Ingredients(ingredientId),
    instructions    VARCHAR(100), 
    PRIMARY KEY(recipeId, ingredientId)
);
GO

CREATE TABLE UserLikes (
    recipeId        INT      NOT NULL   FOREIGN KEY REFERENCES Recipes(recipeId),
    userId          INT      NOT NULL   FOREIGN KEY REFERENCES Users(userId),
    PRIMARY KEY(recipeId, userId)
);
GO

/**************************************************************************************************             
									        VIEWS
 **************************************************************************************************/
 /*
    Name: vwRecipeDetails
    Author: G. Krynski 
 */
CREATE VIEW vwRecipeDetails AS
    SELECT  r.recipeId,
            r.recipeName,
            rt.[description] AS [recipeType],
            r.timeInMinutes,
            dl.difficultyLevelId AS [difficultyLevel], 
            d.[description] AS [dietType],
            r.ownerId,
            u.fName + ' ' + u.lName AS [recipeOwner],
            [IngredientList] = (
                SELECT i.ingredientName
                FROM RecipeIngredients ri
                    JOIN Ingredients i ON ri.ingredientId = i.ingredientId
                WHERE ri.recipeId = r.recipeId
                FOR JSON PATH
            )
    FROM Recipes r
    JOIN RecipeTypes rt 
        ON rt.recipeTypeId = r.recipeTypeId
    JOIN DifficultyLevel dl 
        ON dl.difficultyLevelId = r.difficultyLevelId
    JOIN Diets d 
        ON d.dietId = r.dietId
    JOIN Users u 
        ON u.userId = r.ownerId
GO


/*
    Name: vwNumOfRecipeLikes
    Author: G. Krynski 
 */
CREATE VIEW vwNumOfRecipeLikes AS
    SELECT  rd.recipeId, rd.recipeName,
            [NumberOfLikes] = (
            SELECT COUNT(*) 
            FROM UserLikes ul 
            WHERE ul.recipeId =rd.recipeId
            )
    FROM vwRecipeDetails rd
    GROUP BY rd.recipeId, rd.recipeName    
GO

/*
    Name: vwNumOfRecipeLikes
    Author: G. Krynski 
 */
CREATE VIEW vwIngredientList AS
    SELECT i.ingredientName, r.recipeId
    FROM RecipeIngredients ri
        JOIN Ingredients i ON ri.ingredientId = i.ingredientId
        JOIN Recipes r ON ri.recipeId = r.recipeId
GO


/**************************************************************************************************             
										STORED PROCEDURES
 **************************************************************************************************/

/* =====================================================================
    Name: spLogin
    Author: G.Krynski
    Written: 4/19/20
    Purpose: To validate user login
    Returns: 1 if login was successful,
             0 if login was not successful
======================================================================== */
CREATE PROCEDURE spLogin
    @userEmail   VARCHAR(100),
    @userPassword   NVARCHAR(4000)
AS BEGIN
    IF EXISTS (SELECT NULL 
                FROM Users 
                WHERE userEmail = @userEmail and userPassword = HASHBYTES('SHA2_512', @userPassword)
            )
        SELECT [login] = CAST(1 AS BIT)
    ELSE    
        SELECT [login] = CAST(0 AS BIT)
END
GO

/* =====================================================================
    Name: spChangePassword
    Author: G.Krynski
    Written: 4/19/20
    Purpose: To change the users current password to a new password
    Returns: 1 if password change was successful,
             0 if not successful
======================================================================== */
CREATE PROCEDURE spChangePassword
    @userEmail          VARCHAR(100),
    @userPassword       NVARCHAR(4000),
    @newUserPassword    NVARCHAR(4000)
AS BEGIN
    IF EXISTS (SELECT NULL FROM Users WHERE (userEmail = @userEmail) AND (userPassword = HASHBYTES('SHA2_512', @userPassword))) BEGIN
        UPDATE Users SET userPassword = HASHBYTES('SHA2_512', @newUserPassword)
        SELECT CAST(1 AS bit) AS success
    END ELSE BEGIN
        SELECT [errorMessage] = 'Incorrect user email or password'
    END 
END
GO

/* =====================================================================
    Name: spAddUpdateDelete_User
    Author: G.Krynski
    Written: 4/19/20
    Purpose: adds/updates/deletes a user to/from the database
    Returns:-1 if operation did not work. 0 if delete worked
			## the id of the user that was added or updated
======================================================================== */
CREATE PROCEDURE spAddUpdateDelete_User
    @userId             INT,   
    @userName           VARCHAR(100),       
    @fName              VARCHAR(50),  
    @lName              VARCHAR(50),  
    @userEmail          VARCHAR(200), 
    @userPassword       NVARCHAR(4000),
    @gender             CHAR(1),
    @delete             BIT = 0
AS BEGIN
    BEGIN TRAN
        BEGIN TRY
            IF(@userId = 0) BEGIN                                 --ADD
                -- Check if email or username is already in use
                IF NOT EXISTS(SELECT TOP(1) NULL FROM Users WHERE (userEmail = @userEmail) OR (userName = @userName))BEGIN
                    INSERT INTO users(userName, fName, lName, userEmail, userPassword, gender)
                    VALUES (@userName, @fName, @lName, @userEmail, HASHBYTES('SHA2_512', @userPassword), @gender)
                    SELECT @@IDENTITY AS userID
                END ELSE BEGIN
                   SELECT -1 AS userId, 'User already exists' AS [errorMessage]
                END
            END ELSE IF (@delete = 1)BEGIN                        --DELETE
                IF NOT EXISTS (SELECT NULL FROM Users WHERE userId = @userId) BEGIN
                    SELECT -1 AS userId , 'User does not exist' AS [errorMessage]
                END ELSE IF EXISTS (SELECT TOP(1) NULL FROM Recipes WHERE ownerId = @userId) OR
                            EXISTS (SELECT TOP(1) NULL FROM UserLikes WHERE userId = @userId) BEGIN   --SOFT DELETE
                    UPDATE Users SET isDeleted = 1 WHERE userId = @userId
                    SELECT 0 AS userId                                  
                END ELSE BEGIN                                                                          --HARD DELETE
                    DELETE FROM Users WHERE userId = @userId
                    SELECT 0 AS userId
                END
            END ELSE BEGIN                                        --UPDATE
                --Check is email or userName is in use by a user that is not @userId
                IF EXISTS(SELECT NULL FROM Users WHERE (userId <> @userId) AND ((userEmail = @userEmail) OR (userName = @userName))) BEGIN
                    SELECT -1 AS userId, 'This email or userName is currently in use' as [errorMessage]
                END ELSE BEGIN
                    UPDATE Users
                    SET userName     = @userName,     
                        fName        = @fName,        
                        lName        = @lName,        
                        userEmail    = @userEmail,    
                        gender       = @gender       
                    WHERE userId = @userId

                    SELECT @userId AS userId
                END
            END
        END TRY BEGIN CATCH
            IF(@@TRANCOUNT > 0) ROLLBACK TRAN
            SELECT -1 AS recipeId, 'Tran was rolled back' AS [errorMessage]
        END CATCH
    IF(@@TRANCOUNT > 0) COMMIT TRAN
END
GO

/* =====================================================================
    Name: spAddUpdateDelete_Recipe
    Author: G.Krynski
    Written: 4/19/20
    Purpose: adds/updates/deletes a recipe to/from the database
    Returns:-1 if operation did not work. 0 if delete worked
			## the id of the recipe that was added or updated
======================================================================== */
CREATE PROCEDURE spAddUpdateDelete_Recipe
    @recipeId           INT,  
    @recipeTypeId       INT,
    @dietId             INT, 
    @ownerId            INT,
    @difficultyLevelID  INT, 
    @recipeName         VARCHAR(50), 
    @timeInMinutes      INT,
    @delete             bit = 0
AS BEGIN   
    BEGIN TRAN
        BEGIN TRY
            IF(@delete = 1)BEGIN                                --DELETE
                IF NOT EXISTS (SELECT NULL FROM Recipes WHERE recipeId = @recipeId) BEGIN
                    SELECT -1 AS recipeId, 'Recipe does not exist' AS [errorMessage]
                END ELSE BEGIN
                    DELETE FROM Recipes WHERE recipeId = @recipeId AND ownerId = @ownerId
                    DELETE FROM UserLikes WHERE recipeId = @recipeId
                    DELETE FROM RecipeIngredients WHERE recipeId = @recipeId
                    SELECT 0 AS recipeId
                END
            END ELSE IF EXISTS (SELECT NULL FROM Users WHERE userId = @ownerId) AND         --Check if all FK's exists.
                        EXISTS (SELECT NULL FROM RecipeTypes WHERE recipeTypeId = @recipeTypeId) AND
                        EXISTS (SELECT NULL FROM Diets WHERE dietId = @dietId) AND
                        EXISTS (SELECT NULL FROM DifficultyLevel WHERE difficultyLevelId = @difficultyLevelId)BEGIN     
                IF(@recipeId = 0) BEGIN                         --ADD
                    INSERT INTO Recipes (recipeTypeId, dietId, difficultyLevelId, ownerId, recipeName, timeInMinutes)
                    VALUES (@recipeTypeId, @dietId, @difficultyLevelId, @ownerId, @recipeName, @timeInMinutes)
                    SELECT @@IDENTITY AS recipeId
                END ELSE BEGIN                                  --UPDATE
                    UPDATE Recipes
                    SET recipeTypeId        = @recipeTypeId,     
                        dietId              = @dietId,                    
                        difficultyLevelID   = @difficultyLevelID,
                        recipeName          = @recipeName,       
                        timeInMinutes       = @timeInMinutes    
                    WHERE (recipeId = @recipeId) AND (ownerId = @ownerId)
                    SELECT @recipeId as recipeId
                END
            END ELSE BEGIN
                SELECT -1 AS recipeId, 'Foreign keys does not exist' AS [errorMessage]
            END
        END TRY BEGIN CATCH
            IF(@@TRANCOUNT > 0) ROLLBACK TRAN
            SELECT -1 AS recipeId, 'Tran was rolled back' AS [errorMessage]
        END CATCH
    IF(@@TRANCOUNT > 0) COMMIT TRAN
END
GO

/* =====================================================================
    Name: spAddUpdateDelete_RecipeIngredient
    Author: G.Krynski
    Written: 4/19/20
    Purpose: adds/updates/deletes a recipeIngredient to/from the database
    Returns:-1 if operation did not work. 0 if delete worked.
			1 if add or update worked.
======================================================================== */
CREATE PROCEDURE spAddUpdateDelete_RecipeIngredient
    @recipeId       INT,
    @ingredientId   INT,
    @instructions   VARCHAR(100),
    @delete         BIT = 0
AS BEGIN
    BEGIN TRAN
        BEGIN TRY
            IF(@delete = 1) BEGIN                                   --DELETE 
                IF EXISTS (SELECT NULL FROM RecipeIngredients WHERE (recipeId = @recipeId) AND (ingredientId = @ingredientId)) BEGIN
                    DELETE FROM RecipeIngredients WHERE (recipeId = @recipeId) AND (ingredientId = @ingredientId)
                    SELECT 0 as success
                END ELSE BEGIN
                    SELECT -1 AS success, 'RecipeIngredient does not exist' AS [errorMessage]
                END
            END ELSE IF EXISTS (SELECT NULL FROM Recipes WHERE recipeId = @recipeId) AND             --Check if recipe and ingredient exists
                        EXISTS(SELECT NULL FROM Ingredients WHERE ingredientId = @ingredientId) BEGIN
                IF NOT EXISTS(SELECT NULL FROM RecipeIngredients WHERE recipeId = @recipeId AND ingredientId = @ingredientId) BEGIN     --ADD
                    INSERT INTO RecipeIngredients (recipeId, ingredientId, instructions)
                    VALUES (@recipeId, @ingredientId, @instructions)

                    SELECT 1 as success
                END ELSE BEGIN                                     --UPDATE
                    UPDATE RecipeIngredients
                    SET instructions = @instructions
                    WHERE (recipeId = @recipeId) AND (ingredientId = @ingredientId)

                    SELECT 1 as success
                END
            END ELSE BEGIN
                SELECT -1 as success
            END
        END TRY BEGIN CATCH
            IF(@@TRANCOUNT > 0) ROLLBACK TRAN
            SELECT -1 as success, 'Tran rolled back' AS [errorMessage]
        END CATCH
    IF(@@TRANCOUNT > 0) COMMIT TRAN
END
GO 

/* =====================================================================
    Name: spAdd_Ingredient
    Author: G.Krynski
    Written: 4/19/20
    Purpose: adds an new ingredient to the database. Will consider an ingredient 
            new if it has a new ingredient name or an existing ingredient name 
            with a new description.
    Returns: 1 add worked, -1 if it failed
======================================================================== */
CREATE PROCEDURE spAdd_Ingredient
    @ingredientName     VARCHAR(50),
    @description        VARCHAR(200)
AS BEGIN
    BEGIN TRAN
        BEGIN TRY
            IF EXISTS(SELECT NULL FROM Ingredients WHERE (ingredientName = @ingredientName) AND ([description] = @description) )BEGIN
                SELECT -1 AS ingredientID, 'Ingredient already exists'
            END ELSE BEGIN
                INSERT INTO Ingredients (ingredientName, [description])
                VALUES (@ingredientName, @description)

                SELECT @@IDENTITY AS ingredientId
            END
        END TRY BEGIN CATCH
            IF(@@TRANCOUNT > 0) ROLLBACK TRAN
        END CATCH
    IF(@@TRANCOUNT > 0) COMMIT TRAN
END
GO

/* =====================================================================
    Name: spGetRecipeBy_Diet
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns recipes that adhere to the specified diet
======================================================================== */
CREATE PROCEDURE spGetRecipeBy_Diet
	@description	VARCHAR(200)
AS
BEGIN
    IF NOT EXISTS(SELECT NULL FROM vwRecipeDetails WHERE dietType  = @description) BEGIN
        SELECT  [message] = 'Specified diet does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
    END ELSE BEGIN
        SELECT *
        FROM vwRecipeDetails
        WHERE dietType = @description
    END
END
GO

/* =====================================================================
    Name: spGetRecipeBy_User
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns recipes with a specific userId
======================================================================== */
CREATE PROCEDURE spGetRecipeBy_User
	@userName	VARCHAR(100)
AS
BEGIN
    IF NOT EXISTS(SELECT NULL FROM Users WHERE userName = @userName) BEGIN
        SELECT  [message] = 'Specified user does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
    END ELSE BEGIN
        SELECT *
        FROM vwRecipeDetails rd
        WHERE rd.ownerId IN (SELECT userId FROM Users WHERE userName = @userName)
    END
END
GO

/* =====================================================================
    Name: spGetRecipeBy_Ingredient
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns recipes that use the specified ingredient(s)
======================================================================== */
CREATE PROCEDURE spGetRecipeBy_Ingredient
	@ingredientName	VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS(SELECT NULL FROM Ingredients WHERE ingredientName  = @ingredientName) BEGIN
        SELECT  [message] = 'Specified ingredient does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
    END ELSE BEGIN
        SELECT *
        FROM vwRecipeDetails rd
        WHERE @ingredientName IN (SELECT ingredientName FROM vwIngredientList il WHERE rd.recipeId = il.recipeId)
    END
END
GO

/* =====================================================================
    Name: spGetRecipeBy_Time
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns a recipe that is <= a specified time to complete
======================================================================== */
CREATE PROCEDURE spGetRecipeBy_Time
	@timeInMinutes	INT
AS
BEGIN
    IF NOT EXISTS(SELECT NULL FROM vwRecipeDetails WHERE timeInMinutes  = @timeInMinutes) BEGIN
        SELECT  [message] = 'Specified time does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
    END ELSE BEGIN
        SELECT *
        FROM vwRecipeDetails
        WHERE timeInMinutes = @timeInMinutes
    END
END
GO

/* =====================================================================
    Name: spGetDifficultyLevel
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns recipes at the specified difficulty level
======================================================================== */
CREATE PROCEDURE spGetDifficultyLevel
    @difficultyLevelID INT
AS BEGIN
     IF NOT EXISTS (SELECT NULL FROM Recipes WHERE difficultyLevelId = @difficultyLevelID) BEGIN
        SELECT  [message] = 'There is no Recipe at the specified difficulty level'
    END ELSE BEGIN
        SELECT rd.recipeId, rd.recipeName, rd.dietType, rd.difficultyLevel, rd.recipeOwner, rd.IngredientList
        FROM vwRecipeDetails rd
        WHERE rd.difficultyLevel = @difficultyLevelID
    END
END
GO

/* =====================================================================
    Name: spGetRecipeWithoutIngredients
    Author: G.Krynsk
    Written: 4/19/20
    Purpose: Returns all recipes that do not contain a certain ingredient
======================================================================== */
CREATE PROCEDURE spGetRecipeWithoutIngredients
    @ingredientName	VARCHAR(50)
AS BEGIN
     IF NOT EXISTS(SELECT NULL FROM Ingredients WHERE ingredientName  = @ingredientName) BEGIN
        SELECT  [message] = 'Specified ingredient does not exist'
    END ELSE BEGIN
        SELECT DISTINCT rd.*
        FROM vwRecipeDetails rd
        WHERE @ingredientName NOT IN(SELECT ingredientName FROM vwIngredientList il WHERE rd.recipeId = il.recipeId)
    END
END
GO

/* =====================================================================
    Name: spGetRecipeLikes
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns the number of “likes” a recipe has
======================================================================== */
CREATE PROCEDURE spGetRecipeLikes
    @recipeId   INT
AS BEGIN
    IF NOT EXISTS (SELECT NULL FROM Recipes WHERE recipeId = @recipeId) BEGIN
        SELECT  [message] = 'Recipe does not exist'
    END ELSE BEGIN
        SELECT * 
        FROM vwNumOfRecipeLikes
        WHERE recipeId = @recipeId
    END
END
GO

/* =====================================================================
    Name: spGetUserLikedRecipes
    Author: G.Krynski
    Written: 4/19/20
    Purpose: Returns the recipes that the user “liked”
======================================================================== */
CREATE PROCEDURE spGetUserLikedRecipes
    @userId     INT
AS BEGIN
    IF NOT EXISTS(SELECT NULL FROM UserLikes WHERE userId = @userId) BEGIN
        SELECT  [message] = 'User does not have liked Recipes'
    END ELSE BEGIN
        SELECT rd.*
        FROM UserLikes ul
            JOIN vwRecipeDetails rd ON ul.recipeId = rd.recipeId
        WHERE userId = 1
    END
END
GO

 /**************************************************************************************************             
									TABLE POPULATION
 **************************************************************************************************/

SET IDENTITY_INSERT RecipeTypes ON 
INSERT RecipeTypes (recipeTypeId, [description]) VALUES 
(1, 'Breakfast'),
(2, 'Lunch'),
(3, 'Entree'),
(4, 'Dessert'),
(5, 'Drinks'),
(6, 'Side Dish'),
(7, 'Soup'),
(8, 'Snack'),
(9, 'Baked Good'),
(10, 'Appetizer')
SET IDENTITY_INSERT RecipeTypes OFF 
GO

SET IDENTITY_INSERT Diets ON 
INSERT Diets (dietId, [description]) VALUES 
(1, 'Vegan'),
(2, 'Gluten Free'),
(3, 'Vegetarian'),
(4, 'Keto'),
(5, 'Paleo'),
(6, 'Dairy Free'),
(7, 'Low FODMAP'),
(8, 'Mediterranean'),
(9, 'Kosher'),
(10, 'Whole30'),
(11, 'none')
SET IDENTITY_INSERT Diets OFF 
GO

SET IDENTITY_INSERT DifficultyLevel ON 
INSERT DifficultyLevel (difficultyLevelId, [description]) VALUES 
(1, 'Easy'),
(2, 'Moderate'),
(3, 'Hard'),
(4, 'Expert')
SET IDENTITY_INSERT DifficultyLevel OFF 
GO

SET IDENTITY_INSERT Ingredients ON 
INSERT Ingredients (ingredientId, ingredientName) VALUES
(1,'Baking powder'),
(2,'Baking soda'),
(3,'Brown sugar'),
(4,'Cornstarch'),
(5,'All-purpose flour'),
(6,'Granulated sugar'),
(7,'Honey'),
(8,'Butter'),
(9,'sharp cheddar'),
(10,'feta'),
(11,'Parmesan'),
(12,'mozzarella'),
(13,'Large eggs'),
(14,'Milk'),
(15,'Plain yogurt'),
(16,'blackberries'),
(17,'blueberries'),
(18,'peaches'),
(19,'strawberries'),
(20,'broccoli'),
(21,'bell pepper'),
(22,'onion'),
(23,'corn'),
(24,'edamame'),
(25,'peas'),
(26,'spinach'),
(27,'Rice'),
(28,'Rolled oats'),
(29,'bay leaves'),
(30,'cayenne pepper'),
(31,'crushed red pepper'),
(32,'cumin'),
(33,'ground coriander'),
(34,'oregano'),
(35,'paprika'),
(36,'rosemary'),
(37,'thyme leaves'),
(38,'cinnamon'),
(39,'cloves'),
(40,'allspice'),
(41,'ginger'),
(42,'nutmeg')
SET IDENTITY_INSERT Ingredients OFF 
GO

SET IDENTITY_INSERT Users ON 
INSERT Users (userId, userName, fName, lName, userEmail, userPassword, gender) VALUES
(1, 'ykermeen0', 'Yettie', 'Kermeen', 'ykermeen0@google.de', HASHBYTES('SHA2_512','ASkCfs'), 'F'),
(2, 'fkelwick1', 'Fairfax', 'Kelwick', 'fkelwick1@fema.gov', HASHBYTES('SHA2_512','KkcdkHHJubv'), 'M'),
(3, 'rclinning2', 'Rem', 'Clinning', 'rclinning2@ftc.gov', HASHBYTES('SHA2_512','W3S51za6O'), 'M'),
(4, 'doshirine3', 'Daniella', 'O''Shirine', 'doshirine3@gmpg.org', HASHBYTES('SHA2_512','fLgQAs'), 'F'),
(5, 'mmudle4', 'Malynda', 'Mudle', 'mmudle4@woothemes.com', HASHBYTES('SHA2_512','52P8Gm'), 'F'),
(6, 'bcorck5', 'Bevon', 'Corck', 'bcorck5@youku.com', HASHBYTES('SHA2_512','VEyb1EwyW6my'), 'M'),
(7, 'carlt6', 'Courtnay', 'Arlt', 'carlt6@sogou.com', HASHBYTES('SHA2_512','OMzkzeC4uPJ9'), 'F'),
(8, 'rlidster7', 'Rockwell', 'Lidster', 'rlidster7@technorati.com', HASHBYTES('SHA2_512','eO4kR9'), 'M'),
(9, 'xlutwidge8', 'Ximenes', 'Lutwidge', 'xlutwidge8@vkontakte.ru', HASHBYTES('SHA2_512','E9DKdY9hfxZQ'), 'M'),
(10, 'tbech9', 'Traver', 'Bech', 'tbech9@unblog.fr', HASHBYTES('SHA2_512','9g7uSb'), 'M'),
(11, 'sconnora', 'Sibilla', 'Connor', 'sconnora@berkeley.edu', HASHBYTES('SHA2_512','upHBSjJW'), 'F'),
(12, 'ojanatkab', 'Oliver', 'Janatka', 'ojanatkab@bloomberg.com', HASHBYTES('SHA2_512','hqmvzk1zvkG'), 'M'),
(13, 'ccleerec', 'Cori', 'Cleere', 'ccleerec@bigcartel.com', HASHBYTES('SHA2_512','YH4UnijlD2l'), 'M'),
(14, 'ohammandd', 'Orlan', 'Hammand', 'ohammandd@omniture.com', HASHBYTES('SHA2_512','GwuSoM'), 'M'),
(15, 'sschirake', 'Selig', 'Schirak', 'sschirake@adobe.com', HASHBYTES('SHA2_512','FAERKt7lC'), 'M'),
(16, 'bmoiserf', 'Bert', 'Moiser', 'bmoiserf@wunderground.com', HASHBYTES('SHA2_512','ownmgMpgrk'), 'M'),
(17, 'wwissbeyg', 'Worden', 'Wissbey', 'wwissbeyg@cpanel.net', HASHBYTES('SHA2_512','vgQUl8RmclI6'), 'M'),
(18, 'csmolanh', 'Christi', 'Smolan', 'csmolanh@hao123.com', HASHBYTES('SHA2_512','EHOQXt'), 'F'),
(19, 'dstuffinsi', 'Demetre', 'Stuffins', 'dstuffinsi@mashable.com', HASHBYTES('SHA2_512','PgTZJC'), 'M'),
(20, 'doxherdj', 'Devy', 'Oxherd', 'doxherdj@theatlantic.com', HASHBYTES('SHA2_512','JM3RJoJi90p'), 'M')
SET IDENTITY_INSERT Users OFF
GO

SET IDENTITY_INSERT Recipes ON
INSERT INTO Recipes (recipeId, recipeTypeId, dietId, difficultyLevelId, ownerId, recipeName, timeInMinutes) VALUES
(1, 4, 5, 4, 4, 'Ice Cream', 48),
(2, 4, 7, 4, 3, 'Boston Cream Pie', 68),
(3, 8, 3, 2, 11, 'Chocolate Chip Cookies', 10),
(4, 4, 7, 3, 17, 'Cheesecake', 37),
(5, 4, 1, 1, 3, 'Bananas Foster', 61),
(6, 4, 3, 2, 2, 'Pecan Pie', 42),
(7, 4, 9, 1, 14, 'Whoopie Pie', 26),
(8, 8, 6, 2, 7, 'Carrot Cake', 105),
(9, 8, 10, 3, 7, 'Monster Cookies', 87),
(10, 4, 4, 2, 15, 'Chickpea Blondies', 28),
(11, 1, 2, 3, 6, 'Huevos Rancheros', 85),
(12, 1, 1, 1, 13, 'Blueberry Muffins', 24),
(13, 1, 9, 1, 6, 'Sausage Gravy Breakfast Lasagna', 22),
(14, 1, 9, 3, 16, 'Easy Cheese Danish', 96),
(15, 1, 6, 3, 3, 'Instant Pot Mini Frittatas', 92),
(16, 1, 7, 1, 2, 'Banana Sour Cream Pancakes', 38),
(17, 1, 8, 2, 20, 'Scrambled Eggs with Herbs', 39),
(18, 1, 10, 2, 13, 'Breakfast Bread Pudding', 80),
(19, 1, 5, 4, 14, 'Blueberry Scones with Lemon Glaze', 16),
(20, 1, 9, 1, 14, 'Mini Kale Shakshuka', 15),
(21, 3, 9, 4, 9, 'Shrimp Scampi with Linguini', 54),
(22, 4, 2, 2, 11, 'Pan Fried Pork Chops', 51),
(23, 4, 6, 1, 9, 'Perfect Roast Chicken', 20),
(24, 4, 1, 4, 10, 'Oven-Baked Salmon', 110),
(25, 3, 5, 2, 16, 'Slow Cooker Pot Roast', 51),
(26, 3, 8, 4, 4, 'Lemon and Garlic Roast Chicken', 75),
(27, 4, 8, 4, 19, 'Ginger-Glazed Salmon', 78),
(28, 3, 5, 3, 6, 'Cast-Iron Skillet Provencal Pork Chops', 15),
(29, 3, 5, 3, 4, 'Chicken Tetrazzini', 6),
(30, 3, 9, 3, 3, 'Fried Chicken with Black Pepper Gravy', 18),
(31, 4, 6, 3, 4, 'Chicken Cacciatore', 104),
(32, 4, 5, 3, 19, 'Tricolore Stuffed Pork', 106),
(33, 3, 3, 3, 2, 'Peppercorn Roasted Beef Tenderloin', 89),
(34, 3, 5, 3, 6, 'Chicken Stew with Biscuits', 83),
(35, 4, 1, 1, 1, 'The Best Chicken Tikka Masala', 71),
(36, 3, 10, 3, 1, 'Rhubarb Short Ribs', 31),
(37, 3, 4, 3, 17, 'Vegetarian Lasagna', 26),
(38, 3, 3, 1, 2, 'Valeries Very Best Gumbo', 8),
(39, 4, 10, 4, 11, 'Roasted Shrimp and Orzo', 39),
(40, 4, 2, 3, 16, 'Sunday Rib Roast', 78),
(41, 5, 1, 4, 1, 'Margarita', 101),
(42, 5, 6, 2, 10, 'Old-Fashioned', 24),
(43, 5, 6, 4, 18, 'Hot Chocolate', 105),
(44, 5, 4, 2, 6, 'Trash Can', 57),
(45, 5, 7, 1, 5, 'Blackberry Lemonde', 109),
(46, 6, 10, 3, 5, 'Baked French Fries', 99),
(47, 6, 6, 3, 12, 'Coleslaw', 6),
(48, 6, 7, 4, 19, 'Oven Roasted Redskin Potatoes', 69),
(49, 6, 1, 4, 6, 'Caesar Salad', 28),
(50, 6, 6, 2, 11, 'Broccoli Slaw Salad', 83),
(51, 7, 1, 4, 18, 'Butternut Squash Soup', 97),
(52, 7, 2, 2, 7, 'Lobster Bisque', 78),
(53, 7, 2, 2, 1, 'Clam Chowder', 30),
(54, 9, 1, 3, 9, 'Bacon Wrapped Dates', 54),
(55, 9, 8, 1, 2, 'Spinach Artichoke Dip', 98),
(56, 9, 10, 4, 9, 'Potato Skins', 8)
SET IDENTITY_INSERT Recipes OFF

INSERT INTO RecipeIngredients (recipeId, ingredientId) VALUES
(49, 37),
(5, 42),
(42, 7),
(51, 38),
(17, 5),
(6, 9),
(44, 34),
(39, 16),
(24, 36),
(30, 14),
(4, 29),
(29, 7),
(12, 35),
(3, 1),
(54, 35),
(43, 35),
(55, 21),
(7, 11),
(55, 40),
(31, 11),
(21, 33),
(42, 29),
(39, 24),
(27, 34),
(14, 4),
(48, 27),
(14, 29),
(23, 40),
(3, 19),
(5, 10),
(11, 28),
(26, 5),
(54, 28),
(38, 36),
(26, 23),
(35, 6),
(41, 10),
(2, 16),
(38, 32),
(55, 24),
(28, 30),
(20, 15),
(18, 22),
(35, 33),
(13, 32),
(40, 2),
(22, 22),
(33, 25),
(44, 27),
(27, 19),
(30, 15),
(5, 27),
(11, 21),
(44, 31),
(2, 32),
(38, 22),
(4, 20),
(52, 33),
(38, 3),
(33, 33),
(13, 9),
(46, 23),
(2, 36),
(1, 36),
(13, 35),
(51, 24),
(38, 39),
(11, 40),
(25, 3),
(43, 10),
(53, 42),
(2, 21),
(45, 5),
(17, 23),
(45, 19),
(6, 42),
(27, 35),
(32, 30),
(39, 29),
(38, 27),
(4, 7),
(16, 41),
(27, 39),
(53, 27),
(39, 11),
(27, 21),
(38, 7),
(54, 26),
(2, 11),
(37, 1),
(47, 14),
(11, 13),
(17, 24),
(52, 41),
(42, 35),
(40, 27)

INSERT INTO UserLikes (recipeId, userId) VALUES
(33, 12),
(18, 6),
(31, 6),
(8, 9),
(37, 13),
(41, 18),
(51, 14),
(13, 10),
(36, 13),
(3, 5),
(51, 3),
(43, 18),
(43, 6),
(14, 3),
(42, 4),
(9, 8),
(33, 5),
(18, 17),
(19, 1),
(30, 3),
(14, 2),
(42, 7),
(10, 5),
(36, 8),
(34, 10),
(38, 12),
(23, 2),
(40, 9),
(50, 4),
(43, 16),
(13, 19),
(31, 1),
(6, 20),
(8, 20),
(34, 15),
(9, 9),
(36, 20),
(53, 17),
(50, 18),
(6, 15),
(6, 18),
(32, 4),
(3, 17),
(35, 19),
(30, 2),
(41, 15),
(23, 4),
(28, 1),
(42, 18),
(6, 11),
(35, 20),
(11, 10),
(1, 19),
(33, 14),
(28, 8),
(3, 18),
(24, 9),
(54, 1),
(9, 11),
(26, 12),
(31, 12),
(5, 19),
(21, 4),
(18, 5),
(5, 11),
(7, 5),
(5, 12),
(48, 9),
(21, 5),
(18, 18),
(39, 18),
(46, 10),
(48, 8),
(33, 7),
(24, 10),
(53, 20),
(5, 17),
(39, 1),
(3, 13),
(4, 10),
(34, 8),
(9, 14),
(2, 20),
(55, 2),
(51, 13),
(32, 13),
(51, 5),
(35, 18),
(55, 15),
(4, 2),
(50, 16),
(14, 1),
(26, 6),
(41, 4),
(17, 15)

 /**************************************************************************************************             
										TESTING
 **************************************************************************************************/
------------------------------- Test spAddUpdateDelete_User ------------------------------------
-- select * from Users

-- spAddUpdateDelete_User 0, 'ginak', 'gina', 'k', 'ginak@gmail.com', 'password', 'F', 0                  --Should return userId for new user  
-- select * from Users

-- spAddUpdateDelete_User 21, 'ginak10', 'Gina', 'Krynski', 'ginakryn@gmail.com', 'password123', 'M', 0   --Should not update password
-- select * from Users

-- spAddUpdateDelete_User 0, 'ginak10', 'Gina', 'Krynski', 'ginakryn@gmail.com', 'password123', 'M', 0   --Should Fail, user already exists
-- select * from Users

-- spAddUpdateDelete_User 21, 'ginak10', 'Gina', 'Krynski', 'ginakryn@gmail.com', 'password123', 'M', 1   --Should delete user
-- select * from Users

-- spAddUpdateDelete_User 21, 'ginak10', 'Gina', 'Krynski', 'ginakryn@gmail.com', 'password123', 'M', 1   --Should fail, user does not exist

------------------------------- Test spLogin --------------------------------------------------
-- Select * From Users
-- spAddUpdateDelete_User 0, 'ginak', 'gina', 'k', 'ginak@gmail.com', 'password', 'F', 0       --Should return userId for new user  

-- spLogin 'ginak@gmail.com', 'password'   -- Should return 1 as success

-- spLogin 'ginak@gmail.com', 'password1'  -- Should return 0 as fail

-- spLogin 'gina@gmail.com', 'password'  -- Should return 0 as fail

-- spAddUpdateDelete_User 21, 'ginak', 'gina', 'k', 'ginak@gmail.com', 'password', 'F', 1       --Should delete user

-- spLogin 'ginak@gmail.com', 'password'   -- Should return 0 as success

------------------------------- Test spChangePassword -----------------------------------------
-- Select * From Users
-- spAddUpdateDelete_User 0, 'ginak', 'gina', 'k', 'ginak@gmail.com', 'password', 'F', 0       --Should return userId for new user  

-- spLogin 'ginak@gmail.com', 'password'   -- Should return 1 as success

-- spChangePassword 'ginak@gmail.com', 'password1', 'password2' --Should fail, not correct current password

-- spChangePassword 'gina@gmail.com', 'password', 'password2' --Should fail, not correct current password

-- spChangePassword 'ginak@gmail.com', 'password', 'password2' --Should change password

-- spLogin 'ginak@gmail.com', 'password2'   -- Should return 1 as success

------------------------------- Test spAddUpdateDelete_Recipe ---------------------------------
-- select * from Recipes

-- spAddUpdateDelete_Recipe 0, 4, 11, 1, 3, 'Denver omlete', 15, 0        --Should return userId for new user  
-- select * from Recipes

-- spAddUpdateDelete_Recipe 57, 5, 11, 1, 3, 'Denver Egg Omlete', 12, 0   --Should update recipe
-- select * from Recipes

-- spAddUpdateDelete_Recipe 57, 5, 11, 1, 3, 'Denver Egg Omlete', 12, 1   --Should delete recipe
-- select * from Recipes

-- spAddUpdateDelete_Recipe 57, 5, 11, 1, 3, 'Denver Egg Omlete', 12, 1  -- Should fail, Recipe Does not exist

-- spAddUpdateDelete_Recipe 57, 5, 11, 1, 100, 'Denver Egg Omlete', 12, 0  -- Should fail, Foreign key Does not exist (userId)

------------------------------- Test spAddUpdateDelete_RecipeIngredient ----------------------
-- Select * From RecipeIngredients

-- spAddUpdateDelete_RecipeIngredient  1, 6, 'bake at 350' -- Should return 1 as success, add RecipeIngredient
-- Select * From RecipeIngredients

-- spAddUpdateDelete_RecipeIngredient  1, 6, 'bake at 350' -- Should return 1 as success, but doesn't add a duplicate.
-- Select * From RecipeIngredients

-- spAddUpdateDelete_RecipeIngredient  1, 6, 'pressure cooker needed' -- Should return 1 as success, update RecipeIngredient.
-- Select * From RecipeIngredients

-- spAddUpdateDelete_RecipeIngredient  1, 6, 'pressure cooker needed', 1 -- Should return 0 as success, delete RecipeIngredient.
-- Select * From RecipeIngredients

-- spAddUpdateDelete_RecipeIngredient  1, 6, 'pressure cooker needed', 1 -- Should return -1 as fail, RecipeIngredient does not exist.

------------------------------- Test spAdd_Ingredient ---------------------------------------
-- Select * FROM Ingredients

-- spAdd_Ingredient 'egg', '70 calories'                   --Should return new id
-- Select * FROM Ingredients

-- spAdd_Ingredient 'Egg', '70 calories'                   --Should fail, 

-- spAdd_Ingredient 'baking powder', ''                    --Should fail

-- spAdd_Ingredient 'baking powder', '1 Tbsp per serving'   --Should return new id
-- Select * FROM Ingredients

------------------------------- Test spGetDifficultyLevel -----------------------------------
-- -- SELECT difficultyLevelId FROM Recipes

-- spGetDifficultyLevel 1      -- 11 rows
-- spGetDifficultyLevel 2      -- 13 rows
-- spGetDifficultyLevel 3      -- 18 rows
-- spGetDifficultyLevel 4      -- 14 rows
-- spGetDifficultyLevel 5   --has no recipes
--                             -- 56 total

------------------------------- Test spGetRecipeWithoutIngredients --------------------------
-- SELECT * FROM vwRecipeDetails                                                --56 Recipes total
-- SELECT * FROM vwRecipeDetails WHERE IngredientList IS NULL                  -- 9 Recipes no ingredients

-- SELECT DISTINCT recipeId FROM RecipeIngredients WHERE ingredientId = 7      -- 4 recipes with honey
-- spGetRecipeWithoutIngredients honey                                             -- Should be 52 Recipes

-- SELECT DISTINCT recipeId FROM RecipeIngredients WHERE ingredientId = 12      -- 0 recipes with mozzarella
-- spGetRecipeWithoutIngredients mozzarella                                             -- Should be 56 Recipes

----------------------------- Test spGetRecipeLikes -----------------------------------------
-- Select * FROM vwRecipeLikes

-- spGetRecipeLikes 12         -- Should have 0 likes
-- spGetRecipeLikes 3          -- Should have 4 likes
-- spGetRecipeLikes 60         --Recipe does not exist

----------------------------- Test spGetUserLikedRecipes -------------------------------------
-- SELECT * FROM UserLikes WHERE userId = 1    --Six rows
-- spGetUserLikedRecipes 1                     --Should be six results

-- SELECT * FROM UserLikes WHERE userId = 3    --three rows
-- spGetUserLikedRecipes 3                     --Should be three results

-- spAddUpdateDelete_User 0, 'ginak', 'gina', 'k', 'ginak@gmail.com', 'password', 'F', 0  --User with no likes
-- spGetUserLikedRecipes 21        -- user does not have liked recipes

------------------------------- Test vwRecipeDetails -----------------------------------------
-- SELECT * FROM vwRecipeDetails

----------------------------- Test spGetRecipeBy_Diet ----------------------------------------
--SELECT * FROM Recipes WHERE dietId = 4      --3 rows
--EXEC spGetRecipeBy_Diet keto                --Should have 3 recipes
--
--SELECT * FROM Recipes WHERE dietId = 1      --8 rows
--EXEC spGetRecipeBy_Diet vegan               --Should have 8 recipes
--
--EXEC spGetRecipeBy_Diet veggie       --Diet does not exist

----------------------------- Test spGetRecipeBy_Ingredient ----------------------------------
--SELECT * FROM RecipeIngredients WHERE ingredientId = 38      --1 row
--EXEC spGetRecipeBy_Ingredient cinnamon                       --Should have 1 recipe
--
--SELECT * FROM RecipeIngredients WHERE ingredientId = 32      --3 rows
--EXEC spGetRecipeBy_Ingredient cumin                          --Should have 3 recipes
--
--EXEC spGetRecipeBy_Ingredient chicken                        --Ingredient does not exist

----------------------------- Test spGetRecipeBy_Time ----------------------------------------
--SELECT * FROM Recipes WHERE timeInMinutes = 68  --1 row
--EXEC spGetRecipeBy_Time 68                      --Should have 1 recipe
--
--SELECT * FROM Recipes WHERE timeInMinutes = 28  --2 rows
--EXEC spGetRecipeBy_Time 28                      --Should have 2 recipes
--
--EXEC spGetRecipeBy_Time 58                      --Time does not exist

----------------------------- Test spGetRecipeBy_User ----------------------------------------
--SELECT * FROM Recipes WHERE ownerId = 6             --6 rows
--EXEC spGetRecipeBy_User bcorck5                     --Should have 6 recipes
--
--SELECT * FROM Recipes WHERE ownerId = 7             --3 rows
--EXEC spGetRecipeBy_User carlt6                      --Should have 3 recipes
--
--EXEC spGetRecipeBy_User mkc99                       --User does not exist