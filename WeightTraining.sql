/*
    WeightTraining Database Script
    4.12.2020
    Gina Krynski 
*/

USE master;
GO

DROP DATABASE IF EXISTS WeightTraining;
GO

CREATE DATABASE WeightTraining;
GO

USE WeightTraining;
GO

--========================================== Tables
CREATE TABLE Users (
    userId          UNIQUEIDENTIFIER    NOT NULL    PRIMARY KEY    DEFAULT(NEWID()),
    fName           VARCHAR(50)         NOT NULL,
    lName           VARCHAR(50)         NOT NULL,
    userEmail       VARCHAR(200)        NOT NULL,
    userPassword    VARBINARY(64)       NOT NULL,
    gender          CHAR(1)             NOT NULL,
    currentWeight   FLOAT               NOT NULL    DEFAULT(0),
);
GO

CREATE TABLE ExercisePlans (
    exercisePlanId  UNIQUEIDENTIFIER    NOT NULL    PRIMARY KEY     DEFAULT(NEWID()),
    userId          UNIQUEIDENTIFIER                FOREIGN KEY REFERENCES Users(userId)    NULL,
    planName        VARCHAR(200)         NOT NULL,
    planDate        DATETIME            NOT NULL,
);
GO

CREATE TABLE Exercises(
    exerciseId          UNIQUEIDENTIFIER    NOT NULL    PRIMARY KEY     DEFAULT(NEWID()),
    userId              UNIQUEIDENTIFIER    NOT NULL    FOREIGN KEY REFERENCES Users(userId),
    exerciseName        VARCHAR(50)         NOT NULL,
    exerciseDescription VARCHAR(50)         NOT NULL    DEFAULT(''),
    exerciseVideoLink   VARCHAR(100)        NULL,
);
GO 

CREATE TABLE ExercisePlanDetails(
    exercisePlanDetailId    UNIQUEIDENTIFIER    NOT NULL    PRIMARY KEY     DEFAULT(NEWID()),
    exercisePlanId          UNIQUEIDENTIFIER    NOT NULL    FOREIGN KEY REFERENCES ExercisePlans(exercisePlanId),
    exerciseId              UNIQUEIDENTIFIER    NOT NULL    FOREIGN KEY REFERENCES Exercises(exerciseId),
    weight                  FLOAT               NOT NULL    DEFAULT(0),
    countOf                 INT                 NOT NULL    DEFAULT(0),
    distance                FLOAT               NOT NULL    DEFAULT(0),
    timeInSeconds           INT                 NOT NULL    DEFAULT(0),
);
GO

--========================================== Data
--==============Users
INSERT INTO Users (userId, fName, lName, userEmail, userPassword, gender, currentWeight) VALUES
('baedc3df-73d5-4bdd-be30-dcca61bf64e7', 'Jamil', 'Bellfield', 'jbellfield0@taobao.com', HASHBYTES('SHA2_512','AmKJjpcVL'), 'M', 164),
('004b6c07-51f5-485a-900c-d7564e33870c', 'Willette', 'Boys', 'wboys1@netvibes.com', HASHBYTES('SHA2_512','uoteNE'), 'F', 270),
('4903a668-56a8-4b39-9606-a89ea1a73ec4', 'Fran', 'Clavering', 'fclavering2@liveinternet.ru', HASHBYTES('SHA2_512','le3O4kK'), 'M', 364),
('9dd2f337-3ade-41ac-8f4c-d28198a2d403', 'Kevin', 'Haxley', 'khaxley3@dropbox.com', HASHBYTES('SHA2_512','HG34kHCoD'), 'M', 123),
('bee26084-9696-45d5-aa0e-8556bcf64aae', 'Aleksandr', 'Kempstone', 'akempstone4@samsung.com', HASHBYTES('SHA2_512','FIH1Xf'), 'M', 127),
('fb03d684-f9a0-4983-ac8b-ec8c3e5d0208', 'Drud', 'Kerner', 'dkerner5@admin.ch', HASHBYTES('SHA2_512','26M7so9'), 'M', 365),
('6d6542ad-574f-476a-895e-3e3d8e4ed83d', 'Lea', 'Bellham', 'lbellham6@samsung.com', HASHBYTES('SHA2_512','qykD4V6'), 'F', 224),
('22a6a4fd-c3ff-4d2e-86f3-0cca34aa17be', 'Corenda', 'Corbishley', 'ccorbishley7@xinhuanet.com', HASHBYTES('SHA2_512','DeHF16jANr'), 'F', 197),
('977682c9-c58f-4c00-ae8d-8de2ee6c0570', 'Cymbre', 'Gierardi', 'cgierardi8@soundcloud.com', HASHBYTES('SHA2_512','sxhrYdiafu'), 'F', 135),
('ad7a612f-e734-4a28-b97f-c66c0bf224c8', 'Maddie', 'Emanuelli', 'memanuelli9@sourceforge.net', HASHBYTES('SHA2_512','uZoGHNkev'), 'M', 123),
('3d0cab12-0064-4d30-a5c9-4c2dd1592e60', 'Alfredo', 'Seeman', 'aseemana@usa.gov', HASHBYTES('SHA2_512','0Rz8LXhv5d'), 'M', 463),
('3da61655-ee37-47aa-8c1f-2a1c0ba78bc3', 'Jammal', 'Habbershon', 'jhabbershonb@army.mil', HASHBYTES('SHA2_512','sZ8RP1oj'), 'M', 482),
('1febc0cf-5b95-4bd3-ab60-ffdf26d4e6ab', 'Joel', 'Walling', 'jwallingc@cafepress.com', HASHBYTES('SHA2_512','zh7IeHlSB0kT'), 'M', 401),
('e6d0e5e5-0163-4197-bb5a-1e2014ddc16d', 'Raychel', 'Jordine', 'rjordined@hexun.com', HASHBYTES('SHA2_512','Phz1rVgdpVS'), 'F', 166),
('8bddb833-7b07-4386-89da-8b4ba13a261b', 'Rolf', 'Matisse', 'rmatissee@goodreads.com', HASHBYTES('SHA2_512','46Y9zeS0uW'), 'M', 383),
('3a03f4f2-b243-4485-8923-c6057040a1ee', 'Sanson', 'Jacketts', 'sjackettsf@uol.com.br', HASHBYTES('SHA2_512','egk1LsGMhF81'), 'M', 282),
('c2017a6f-9412-4872-98c2-c83dc2fbb5e7', 'Dane', 'Redgewell', 'dredgewellg@npr.org', HASHBYTES('SHA2_512','0rlBG2Enq'), 'M', 322),
('c3249f34-561a-402a-bd3d-2b0f58c9b39d', 'Louie', 'MacVicar', 'lmacvicarh@toplist.cz', HASHBYTES('SHA2_512','Yz5Kt0S'), 'M', 448),
('a37c7bf0-6b1c-4c0a-978f-aa4bad5018c0', 'Sherlock', 'Danielsson', 'sdanielssoni@theguardian.com', HASHBYTES('SHA2_512','w8bKr9'), 'M', 136),
('a7c789a0-e96a-4c3e-9500-cf2829558381', 'Noam', 'Abby', 'nabbyj@uiuc.edu', HASHBYTES('SHA2_512','3unpwySGD'), 'M', 422),
('3148b71a-00bb-4eaa-b1f0-bd4724073150', 'Carolann', 'Vedyashkin', 'cvedyashkink@samsung.com', HASHBYTES('SHA2_512','OlIiwLip3V2H'), 'F', 171),
('6e5f9bb5-676b-40de-8046-b2975709c103', 'Pernell', 'Bolderoe', 'pbolderoel@mac.com', HASHBYTES('SHA2_512','AasfWcXg'), 'M', 482),
('f37fa036-a012-4557-bbf2-45c92ed78016', 'Erhart', 'Yakebovitch', 'eyakebovitchm@tumblr.com', HASHBYTES('SHA2_512','YUUwyDGFNoXJ'), 'M', 142),
('29f6b21a-f9d6-4b06-a331-1d23a644f8d5', 'Meridel', 'Checketts', 'mcheckettsn@examiner.com', HASHBYTES('SHA2_512','4ipmGoWUw'), 'F', 281),
('b122e4df-4bff-4fc7-8900-fecabb1e51b9', 'Myrtice', 'Seniour', 'mseniouro@jugem.jp', HASHBYTES('SHA2_512','D30XN4xPNG7'), 'F', 369),
('255959b5-bf65-4de1-bee1-ade501bfb91c', 'Edeline', 'Guilfoyle', 'eguilfoylep@cnbc.com', HASHBYTES('SHA2_512','mkd3a0jA'), 'F', 160),
('fca446ee-0b29-481f-a6fa-27ce0ffc666e', 'Maud', 'Pexton', 'mpextonq@lulu.com', HASHBYTES('SHA2_512','IhfxbH0zR'), 'F', 171),
('fbe36e75-6671-4a5e-89af-197d9a885279', 'Tobit', 'Sidgwick', 'tsidgwickr@webs.com', HASHBYTES('SHA2_512','8R6Y9bqne3P'), 'M', 387),
('ae312b79-e40b-4832-aa65-735b15577274', 'Balduin', 'Lavis', 'blaviss@feedburner.com', HASHBYTES('SHA2_512','VqVYznYaZ1nK'), 'M', 262),
('46f8faef-b62e-4e21-8930-d3649d17c17b', 'Bevvy', 'McCrostie', 'bmccrostiet@state.tx.us', HASHBYTES('SHA2_512','AGQluo00'), 'F', 194),
('53b4894c-4461-4ae6-aeab-e1d4ae10bd45', 'Millard', 'Corteney', 'mcorteneyu@linkedin.com', HASHBYTES('SHA2_512','YRZLMvYws9E'), 'M', 428),
('ec9c972f-ea09-4100-b8b1-5fe63c9f0fcb', 'Sheryl', 'Ivory', 'sivoryv@bloglines.com', HASHBYTES('SHA2_512','rK13MAc3'), 'F', 208),
('e516072f-29bf-4d3d-b087-4839876e03d4', 'Elysee', 'Fanshaw', 'efanshaww@google.co.uk', HASHBYTES('SHA2_512','qrMlAqIL7'), 'F', 219),
('592e86cb-3097-4e65-afff-5d8bd4500abe', 'Shela', 'Meins', 'smeinsx@noaa.gov', HASHBYTES('SHA2_512','EovWBmjp5'), 'F', 190),
('48403bac-fb50-418d-b490-2e0126daaaca', 'Stacee', 'Gilhouley', 'sgilhouleyy@macromedia.com', HASHBYTES('SHA2_512','BD9TWmwLD'), 'M', 469),
('0ae8c650-75a0-4470-b4ab-0169210a21e8', 'Selene', 'Orrin', 'sorrinz@arizona.edu', HASHBYTES('SHA2_512','HoshoSOc0'), 'F', 254),
('0d68d5ac-7278-4038-bbee-fa1e88b4f72a', 'Burk', 'Abrahamsohn', 'babrahamsohn10@nature.com', HASHBYTES('SHA2_512','RTB32yrfyN'), 'M', 231),
('cd75c1cf-1785-4beb-a1c3-d8a7a1af3dad', 'Shandra', 'Allkins', 'sallkins11@webnode.com', HASHBYTES('SHA2_512','68Zk8Tsseky'), 'F', 116),
('dc2961aa-1e26-4ec8-ae89-adaf92bcbca0', 'Obed', 'Argrave', 'oargrave12@vk.com', HASHBYTES('SHA2_512','TaP6Fj5FO5'), 'M', 188),
('8e0fa8c6-4898-4579-a32a-9c950edf3ef2', 'Annabel', 'Beekmann', 'abeekmann13@buzzfeed.com', HASHBYTES('SHA2_512','mRGkl3'), 'F', 361),
('7dfac3cf-748d-400f-bf81-14079fb46a7b', 'Corina', 'Gormally', 'cgormally14@nifty.com', HASHBYTES('SHA2_512','gyVjvD'), 'F', 364),
('769043a3-448d-4769-9a2a-cf9b280a0ac9', 'Cleveland', 'Lorraine', 'clorraine15@netvibes.com', HASHBYTES('SHA2_512','zaN3hUEPIm'), 'M', 134),
('fbde9e77-9bcc-490e-a19c-5e8d6f5b8ce8', 'Bessie', 'Fusedale', 'bfusedale16@biblegateway.com', HASHBYTES('SHA2_512','mzWsMAG'), 'F', 181),
('33ae79c5-5eb5-4e6c-9c8d-6f68f827a20f', 'Garth', 'Franceschi', 'gfranceschi17@ocn.ne.jp', HASHBYTES('SHA2_512','ZYAUlf3n'), 'M', 384),
('761bab74-22b2-4263-94e2-88cb6d94b675', 'Lorrie', 'Wrassell', 'lwrassell18@instagram.com', HASHBYTES('SHA2_512','czKMTQe'), 'F', 165),
('e94ea2b0-3f29-461a-810d-dc305c530367', 'Trude', 'Wildor', 'twildor19@aboutads.info', HASHBYTES('SHA2_512','rRwF1t1X2v'), 'F', 284),
('a3e0ad45-5639-47b0-b600-7422cebfb52e', 'Milissent', 'Bryett', 'mbryett1a@weather.com', HASHBYTES('SHA2_512','JkZEdOpZBw7'), 'F', 302),
('e287d9d2-d289-46bd-8465-ad44f767adfc', 'Meade', 'Sapena', 'msapena1b@exblog.jp', HASHBYTES('SHA2_512','qKRlc2Q'), 'M', 393),
('61841174-becb-41f9-a832-99266851a5e6', 'Nomi', 'Hallworth', 'nhallworth1c@networksolutions.com', HASHBYTES('SHA2_512','DJVwTa6v'), 'F', 401),
('9a7460b9-df0d-4b4f-aa28-2b3eebd37989', 'Fredrick', 'Kirvell', 'fkirvell1d@godaddy.com', HASHBYTES('SHA2_512','hj5H08VlsOe'), 'M', 400)

--==============ExercisePlans
INSERT INTO ExercisePlans (exercisePlanId, userId, planName, planDate) VALUES
('a388e011-4540-41a9-953d-6b8b5b3c11aa', '48403bac-fb50-418d-b490-2e0126daaaca', 'HIIT', '8/14/2019'),
('6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', 'ae312b79-e40b-4832-aa65-735b15577274', 'Total Body Tone', '8/12/2019'),
('9c313975-74d8-4571-bf80-5172ae51e509', '48403bac-fb50-418d-b490-2e0126daaaca', 'P90X', '1/28/2020'),
('0cdd350c-c1d4-4de3-8427-a53a22885f58', 'a3e0ad45-5639-47b0-b600-7422cebfb52e', 'Crossfit', '6/10/2019'),
('b62034b2-eb26-4205-9eee-fe0a31377ebb', 'cd75c1cf-1785-4beb-a1c3-d8a7a1af3dad', 'TRX', '3/16/2020'),
('ddb3dc82-d823-4067-937d-0072739258f5', '761bab74-22b2-4263-94e2-88cb6d94b675', 'At-Home', '4/12/2019'),
('5a99c76a-abaf-4e69-84db-cf81498778de', 'fbde9e77-9bcc-490e-a19c-5e8d6f5b8ce8', 'Legs', '9/18/2019'),
('569372cd-762c-40ba-8ee5-c7ed4e88e755', 'fca446ee-0b29-481f-a6fa-27ce0ffc666e', 'Resistance', '5/7/2019')

--==============Exercises
INSERT INTO Exercises (exerciseId, userId, exerciseName, exerciseDescription, exerciseVideoLink) VALUES
('40bc3e33-63f6-45ec-97ec-dcbe2a56a741', '1febc0cf-5b95-4bd3-ab60-ffdf26d4e6ab', 'Squat', 'Acute follicular conjunctivitis', 'http://cnn.com/eget/orci/vehicula/condimentum/curabitur/in.xml'),
('19b668e8-a044-4b87-b8be-44402fc7b78f', 'ad7a612f-e734-4a28-b97f-c66c0bf224c8', 'Leg Press', 'Poisoning by oth drugs acting on muscles', 'http://dot.gov/ipsum/integer/a/nibh/in.json'),
('52fea366-1817-47ec-857b-0891c15c5938', 'dc2961aa-1e26-4ec8-ae89-adaf92bcbca0', 'Lunge', 'Unsp injury of left innominate, sequela', 'http://usgs.gov/eu/nibh/quisque/id/justo/sit.jpg'),
('ed236874-50e2-4985-a4b5-9e39a56380b5', '6e5f9bb5-676b-40de-8046-b2975709c103', 'Deadlift', 'Other voice and resonance disorders', 'https://google.co.jp/orci/pede/venenatis/non/sodales/sed.jpg'),
('0bf39e86-1efb-401e-b353-6277c0a52328', 'a7c789a0-e96a-4c3e-9500-cf2829558381', 'Fly', 'Poisoning by oth synthetic narcotics, subs', 'http://bigcartel.com/sit/amet/consectetuer/adipiscing/elit.xml'),
('0a369299-cc0d-4287-bd80-7d4b8039b8d7', '0d68d5ac-7278-4038-bbee-fa1e88b4f72a', 'Bench Press', 'Antithyroid drugs', 'https://noaa.gov/elementum.aspx'),
('8347203b-438d-4c24-a4fd-b4e9eeb88236', 'fbde9e77-9bcc-490e-a19c-5e8d6f5b8ce8', 'Press-up', 'Person outside pk-up/van inj, subs', 'https://google.co.jp/cursus/id/turpis/integer/aliquet.json'),
('16f1a8e4-f7e5-43e5-94e0-57b12ee79d76', '3da61655-ee37-47aa-8c1f-2a1c0ba78bc3', 'Push-up', 'Poisoning by other hormone antagonists,', 'https://nymag.com/vel/nisl.js'),
('dbff8376-8008-40a5-a8c5-cd67e384e192', '3d0cab12-0064-4d30-a5c9-4c2dd1592e60', 'Dip', 'Oth nondisp fx of lower end of left humerus', 'https://xing.com/lectus/in/quam/fringilla/rhoncus/mauris.xml'),
('4815abb8-6143-463a-b658-b1c097f8fb3d', '977682c9-c58f-4c00-ae8d-8de2ee6c0570', 'Upright Row', 'Laceration of plantar artery of right foot', 'https://hao123.com/ligula/vehicula.jsp'),
('4e81b970-b1cd-41d3-b735-5cf0a6d8e785', 'fca446ee-0b29-481f-a6fa-27ce0ffc666e', 'Curl', 'Major laceration of liver, initial encounter', 'http://123-reg.co.uk/pede/ullamcorper.aspx'),
('379a9ee1-70b2-4a8d-a7ce-9449168448c6', 'ec9c972f-ea09-4100-b8b1-5fe63c9f0fcb', 'Crunch', 'Drown due to fishing boat overturning, init', 'https://timesonline.co.uk/amet/turpis.jsp'),
('0f7005af-6580-4182-b46f-0cd07bb29493', '3a03f4f2-b243-4485-8923-c6057040a1ee', 'Sit-up', 'Disorder of amniotic fluid and membrns', 'http://purevolume.com/nunc/commodo/placerat/praesent/blandit.png'),
('43a522fc-9e69-4abc-9e56-76eb3424068f', 'e287d9d2-d289-46bd-8465-ad44f767adfc', 'Russian Twist', 'Maternal care for benign tumor of corpus uteri', 'http://infoseek.co.jp/montes/nascetur/ridiculus/mus/vivamus.png'),
('281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', '977682c9-c58f-4c00-ae8d-8de2ee6c0570', 'Plank', 'Adverse effect of unsp systemic antibiotic', 'http://seattletimes.com/tristique/est/et.png')

--==============ExercisePlanDetails
INSERT INTO ExercisePlanDetails (exercisePlanDetailId,exercisePlanId, exerciseId, weight, countOf, distance, timeInSeconds) VALUES
('ffd2688f-2d99-4429-a73e-066c8bd301c3', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 249, 12, 7, 26),
('a769273d-80ed-4a63-8840-dc3d72582ec0', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '43a522fc-9e69-4abc-9e56-76eb3424068f', 61, 26, 9, 89),
('c9670ffd-87bc-4608-8761-1f40df7b288f', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 76, 1, 6, 118),
('f38e7bab-0a4a-4606-8f35-e3ddd52346d3', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '4e81b970-b1cd-41d3-b735-5cf0a6d8e785', 184, 1, 7, 33),
('dd43cf2e-093c-4343-83d5-e4dc7dbe9ea9', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '43a522fc-9e69-4abc-9e56-76eb3424068f', 201, 25, 9, 52),
('1d10b139-022b-4bad-8986-27987574959b', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '4815abb8-6143-463a-b658-b1c097f8fb3d', 16, 19, 7, 24),
('6420d25b-e7f8-40d9-8fe8-35c1f5027da9', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '16f1a8e4-f7e5-43e5-94e0-57b12ee79d76', 177, 18, 9, 38),
('2506b1a9-0bea-4489-a53e-dc99b6df091c', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 107, 28, 8, 116),
('b189badd-b1d1-4c00-ac49-bbb5e9e69ac3', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', 'ed236874-50e2-4985-a4b5-9e39a56380b5', 145, 10, 10, 104),
('1c044608-3ad5-4d36-8e9a-61a62be059ab', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '0bf39e86-1efb-401e-b353-6277c0a52328', 215, 11, 3, 53),
('35ef92be-580d-430f-86c2-d1ebc36c1037', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '40bc3e33-63f6-45ec-97ec-dcbe2a56a741', 32, 16, 2, 106),
('2dd87d8e-d932-4dfa-aed8-3078d7907842', '9c313975-74d8-4571-bf80-5172ae51e509', '52fea366-1817-47ec-857b-0891c15c5938', 113, 2, 1, 90),
('ca7c9ef6-f430-4971-9ce4-4bb773035983', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '0f7005af-6580-4182-b46f-0cd07bb29493', 241, 19, 3, 75),
('169c150b-9c83-4367-94ca-52bd68baebe6', 'ddb3dc82-d823-4067-937d-0072739258f5', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 86, 2, 10, 48),
('92a8b6bc-ee92-4f1a-808f-95d9f43f0f15', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '0f7005af-6580-4182-b46f-0cd07bb29493', 227, 2, 9, 105),
('2f0f016e-4d90-4217-b1e3-5d1f17ca839e', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '43a522fc-9e69-4abc-9e56-76eb3424068f', 220, 16, 5, 10),
('e59ef8ff-7543-4122-ba5e-05201b8e2092', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '0f7005af-6580-4182-b46f-0cd07bb29493', 36, 16, 8, 90),
('a932b89d-fc2c-4d84-b00c-f88714585e02', '9c313975-74d8-4571-bf80-5172ae51e509', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 132, 23, 9, 58),
('138175f7-c906-48cb-827a-3fc1ae9af007', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '0bf39e86-1efb-401e-b353-6277c0a52328', 155, 10, 4, 35),
('81594612-d81d-4d5e-a6b3-219362ecef87', 'ddb3dc82-d823-4067-937d-0072739258f5', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 120, 5, 3, 34),
('8b26ee8a-aec6-4a5c-887b-69e3c485bd82', '5a99c76a-abaf-4e69-84db-cf81498778de', 'ed236874-50e2-4985-a4b5-9e39a56380b5', 91, 22, 3, 62),
('990c26e3-e30a-4bf3-9f17-30d0db75c97a', 'ddb3dc82-d823-4067-937d-0072739258f5', '52fea366-1817-47ec-857b-0891c15c5938', 24, 17, 6, 34),
('54706ff6-1350-4120-8033-388cffeb98a8', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '40bc3e33-63f6-45ec-97ec-dcbe2a56a741', 248, 12, 9, 66),
('921d05d8-b33f-4c62-9708-b8e7407f04b8', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '52fea366-1817-47ec-857b-0891c15c5938', 82, 11, 9, 11),
('08650d3f-16d6-426c-8298-09552359a42a', 'ddb3dc82-d823-4067-937d-0072739258f5', 'ed236874-50e2-4985-a4b5-9e39a56380b5', 240, 9, 10, 104),
('9fcfde37-80ab-4a93-b048-ec8661e369a1', '9c313975-74d8-4571-bf80-5172ae51e509', '40bc3e33-63f6-45ec-97ec-dcbe2a56a741', 201, 18, 2, 75),
('eed7c433-ea18-4291-a117-393e72e184f9', 'ddb3dc82-d823-4067-937d-0072739258f5', '52fea366-1817-47ec-857b-0891c15c5938', 108, 23, 6, 107),
('b8dc46cd-d801-4a20-bfba-e2b5840c25a2', '569372cd-762c-40ba-8ee5-c7ed4e88e755', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 187, 12, 7, 39),
('f65a9b0f-493e-4b4d-9e88-afa8c823747d', 'ddb3dc82-d823-4067-937d-0072739258f5', '19b668e8-a044-4b87-b8be-44402fc7b78f', 141, 29, 9, 98),
('c1d01fa2-09ac-4292-915a-d3801093bce5', 'ddb3dc82-d823-4067-937d-0072739258f5', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 44, 13, 10, 67),
('6cf3bcef-ea54-4498-ae9b-e67db4447daa', 'ddb3dc82-d823-4067-937d-0072739258f5', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 209, 24, 4, 32),
('eac66150-cb38-4845-843d-5e8ec504a1f8', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '0bf39e86-1efb-401e-b353-6277c0a52328', 55, 17, 10, 31),
('7d0a59de-5b94-4d58-bc8d-7c6875f7a5cd', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 157, 1, 2, 33),
('e164feab-d660-4f03-a267-8268a76d81af', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 41, 26, 2, 28),
('ff8c4aeb-ecba-4871-b1a3-f3efbb0a3a92', '5a99c76a-abaf-4e69-84db-cf81498778de', '4e81b970-b1cd-41d3-b735-5cf0a6d8e785', 107, 15, 7, 64),
('b61f9ec7-bdb1-4908-bb81-69cde7bde64e', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 52, 27, 6, 27),
('7d3bf4df-6842-42f5-b19a-6730536cd3d2', '5a99c76a-abaf-4e69-84db-cf81498778de', '52fea366-1817-47ec-857b-0891c15c5938', 164, 14, 7, 84),
('5ca2d526-8a9e-43d3-8b90-5a07dec0ac0a', '5a99c76a-abaf-4e69-84db-cf81498778de', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 82, 21, 9, 56),
('892635a3-7180-4e73-9833-7e144d1cefbb', '9c313975-74d8-4571-bf80-5172ae51e509', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 154, 2, 9, 51),
('e909f8e8-2066-421e-aa61-0b1b9843addf', 'ddb3dc82-d823-4067-937d-0072739258f5', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 158, 28, 10, 114),
('56ce8c73-8efd-4503-9bc3-51c36f06d18f', '0cdd350c-c1d4-4de3-8427-a53a22885f58', 'ed236874-50e2-4985-a4b5-9e39a56380b5', 207, 16, 1, 71),
('f3d81152-e66a-4cec-849b-b58717de3fb4', 'ddb3dc82-d823-4067-937d-0072739258f5', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 122, 10, 3, 117),
('3dd38c18-99e9-434a-9ccc-b3a178fccff2', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '19b668e8-a044-4b87-b8be-44402fc7b78f', 155, 30, 5, 85),
('5f04a744-c072-40df-879e-a8ca375c0fa6', 'ddb3dc82-d823-4067-937d-0072739258f5', '4e81b970-b1cd-41d3-b735-5cf0a6d8e785', 182, 3, 8, 19),
('dab4308c-5b1e-44da-bdfd-fc4574d64e31', '9c313975-74d8-4571-bf80-5172ae51e509', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 50, 2, 2, 60),
('5522ad8b-80e4-4738-9881-0d3920e2974b', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '43a522fc-9e69-4abc-9e56-76eb3424068f', 165, 4, 6, 51),
('7372f7d1-a6c6-4d9a-9f45-ddef43a11d20', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '0bf39e86-1efb-401e-b353-6277c0a52328', 58, 2, 3, 64),
('b622a244-9efd-4067-844c-9c376d4af85a', '9c313975-74d8-4571-bf80-5172ae51e509', '0f7005af-6580-4182-b46f-0cd07bb29493', 69, 7, 5, 90),
('ad497b65-0e69-4b6c-ba4a-98cf1451162d', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 145, 21, 9, 104),
('035064bf-c549-4d48-86f8-17ce3fbd8ad0', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 198, 23, 8, 67),
('9455f990-7046-4061-8aae-eb4b7c0e4599', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '40bc3e33-63f6-45ec-97ec-dcbe2a56a741', 63, 5, 9, 42),
('d7cd91d9-9677-4272-adb4-be7abd10133a', '9c313975-74d8-4571-bf80-5172ae51e509', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 188, 8, 5, 69),
('f1956709-71a8-4bde-a24f-067d21e07924', '5a99c76a-abaf-4e69-84db-cf81498778de', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 51, 28, 8, 107),
('9ddde8ac-d704-4f1a-8893-1e32f8b3d2a0', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 52, 14, 7, 15),
('828a45c6-18f7-4146-85a4-3463eb74a404', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 215, 13, 1, 14),
('6ce8408f-dcfb-4137-9870-28c3395502d3', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '43a522fc-9e69-4abc-9e56-76eb3424068f', 16, 12, 10, 107),
('c43bc448-2ee4-4434-809f-5383bc54ed10', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '4e81b970-b1cd-41d3-b735-5cf0a6d8e785', 138, 6, 6, 55),
('ee001791-9cf1-442e-8a5d-772acb493366', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '43a522fc-9e69-4abc-9e56-76eb3424068f', 21, 11, 9, 75),
('784821ba-e82d-47a0-9bad-23312078dd3b', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '4815abb8-6143-463a-b658-b1c097f8fb3d', 125, 7, 7, 15),
('a2ad8551-d991-473a-83a5-a982863d917b', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '43a522fc-9e69-4abc-9e56-76eb3424068f', 206, 14, 8, 58),
('c3c289a3-3849-456c-afe8-d34664cf4bc5', '5a99c76a-abaf-4e69-84db-cf81498778de', '43a522fc-9e69-4abc-9e56-76eb3424068f', 91, 5, 2, 91),
('1439769a-02b6-4bd3-9462-fc8e1cffd290', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 183, 12, 9, 11),
('7da8d1de-9ff0-4205-a60f-b95c8ac487d2', '569372cd-762c-40ba-8ee5-c7ed4e88e755', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 72, 26, 1, 32),
('1b76786b-4839-488a-a1be-8af5956d515f', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '4815abb8-6143-463a-b658-b1c097f8fb3d', 20, 20, 4, 39),
('46f52a91-a0bb-4c33-b867-30bbe76d7a5e', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 114, 16, 8, 10),
('bc32b8c9-b893-46e4-a2bf-fd2f36fa34f9', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '43a522fc-9e69-4abc-9e56-76eb3424068f', 54, 20, 4, 32),
('c392f4cc-e7a1-4d70-a1b6-560b5f9b5e2d', '9c313975-74d8-4571-bf80-5172ae51e509', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 191, 19, 7, 107),
('e6aef1d4-efdf-4606-bdf1-a70ef47ad426', '5a99c76a-abaf-4e69-84db-cf81498778de', '40bc3e33-63f6-45ec-97ec-dcbe2a56a741', 93, 3, 7, 64),
('942f5e5d-231a-4579-8972-31da71d6a137', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 54, 14, 8, 110),
('64e98cdf-d445-44d2-963d-70ebffd8a6a9', 'ddb3dc82-d823-4067-937d-0072739258f5', '4815abb8-6143-463a-b658-b1c097f8fb3d', 131, 6, 3, 15),
('553500a5-5f60-4597-9e9f-9af6dc253415', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '40bc3e33-63f6-45ec-97ec-dcbe2a56a741', 250, 24, 2, 76),
('d93a9321-25d8-4133-8bd3-5a3b230bb12f', '0cdd350c-c1d4-4de3-8427-a53a22885f58', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 239, 21, 4, 103),
('e17a918d-84ce-4a84-8b93-3df398d7db72', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 220, 28, 8, 57),
('cbeba804-b94d-49ec-891f-323dc5897a74', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '0f7005af-6580-4182-b46f-0cd07bb29493', 75, 26, 2, 84),
('cf44ed08-460c-454d-bfd6-f9eb8068c500', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 57, 11, 1, 34),
('b599f25d-796d-4fe1-a7d3-08dbf7ecb1b3', '9c313975-74d8-4571-bf80-5172ae51e509', '4815abb8-6143-463a-b658-b1c097f8fb3d', 26, 11, 7, 118),
('9371bf33-4336-41aa-9dd5-6c872ed616ed', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 16, 29, 6, 31),
('96e6c05a-99f2-4690-813a-89567d561766', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '52fea366-1817-47ec-857b-0891c15c5938', 187, 3, 1, 23),
('2bb46c95-4e50-4694-9f40-23b9a41e423e', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '19b668e8-a044-4b87-b8be-44402fc7b78f', 148, 20, 8, 113),
('45e1f686-eee9-4d6a-96e1-09c9a7cc4a7d', '5a99c76a-abaf-4e69-84db-cf81498778de', '52fea366-1817-47ec-857b-0891c15c5938', 214, 24, 7, 24),
('740cfc3d-4fc3-4242-aa00-a7b49b50feb7', '9c313975-74d8-4571-bf80-5172ae51e509', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 189, 15, 6, 20),
('3db0d580-6aa9-4750-8c1f-d20d386523f3', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '4815abb8-6143-463a-b658-b1c097f8fb3d', 195, 7, 4, 53),
('cf9990d2-cd08-41ae-b8d3-3d39039755c0', 'ddb3dc82-d823-4067-937d-0072739258f5', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 35, 9, 7, 15),
('1c652911-8d5b-4a63-8536-98d24861ff05', '569372cd-762c-40ba-8ee5-c7ed4e88e755', '43a522fc-9e69-4abc-9e56-76eb3424068f', 247, 15, 4, 41),
('c345b1c5-b69a-4f09-9761-b75246c2d175', 'ddb3dc82-d823-4067-937d-0072739258f5', '0bf39e86-1efb-401e-b353-6277c0a52328', 140, 2, 6, 25),
('1ef26278-6243-4ccc-8391-82cc99b2a784', '9c313975-74d8-4571-bf80-5172ae51e509', 'dbff8376-8008-40a5-a8c5-cd67e384e192', 54, 7, 6, 86),
('57b2c0fe-7de2-4793-b19a-bc408ad82507', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '52fea366-1817-47ec-857b-0891c15c5938', 20, 28, 6, 89),
('c313cb2e-76d7-4af1-96f5-e4813b29a882', '5a99c76a-abaf-4e69-84db-cf81498778de', '4815abb8-6143-463a-b658-b1c097f8fb3d', 10, 29, 1, 19),
('19f279a5-6a93-49d0-82f0-e3f4818ef9e9', 'ddb3dc82-d823-4067-937d-0072739258f5', '8347203b-438d-4c24-a4fd-b4e9eeb88236', 116, 13, 2, 30),
('4ac37c7e-ae03-447f-ac95-b8015bb08606', 'ddb3dc82-d823-4067-937d-0072739258f5', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 179, 4, 1, 66),
('dc5d72fa-3637-4305-be7e-6c6e497092a5', 'b62034b2-eb26-4205-9eee-fe0a31377ebb', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 12, 13, 9, 119),
('343ec4b3-5e61-43aa-899f-837ae3eff80f', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '379a9ee1-70b2-4a8d-a7ce-9449168448c6', 108, 16, 3, 58),
('f8ee6cbb-4b0d-464e-ba3a-b7e1285001e4', '0cdd350c-c1d4-4de3-8427-a53a22885f58', '4e81b970-b1cd-41d3-b735-5cf0a6d8e785', 89, 26, 4, 93),
('038b73cf-cd74-4353-9235-4bbfa153fc4f', 'ddb3dc82-d823-4067-937d-0072739258f5', '0f7005af-6580-4182-b46f-0cd07bb29493', 93, 1, 9, 69),
('61ebf827-aa92-4d04-81b8-c8c3808c47be', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '281e9aaf-1afd-44f3-a8f4-e4b285b7e76c', 37, 5, 8, 53),
('5d70180b-bf81-4375-8994-19702b591b8f', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', '0f7005af-6580-4182-b46f-0cd07bb29493', 7, 8, 2, 80),
('4ace603f-8aa2-4906-8693-e09cb59710e2', 'a388e011-4540-41a9-953d-6b8b5b3c11aa', '0a369299-cc0d-4287-bd80-7d4b8039b8d7', 217, 11, 6, 100),
('902f5e03-b3d4-4b52-b75c-b32ff9ddbf3b', '9c313975-74d8-4571-bf80-5172ae51e509', '0bf39e86-1efb-401e-b353-6277c0a52328', 130, 12, 9, 51),
('ab42b9b5-4db6-494c-811e-7be8ece55b7a', 'ddb3dc82-d823-4067-937d-0072739258f5', '0f7005af-6580-4182-b46f-0cd07bb29493', 165, 12, 9, 57),
('863e3547-e777-40e0-a5f3-b3b4199ee6e4', '6fa9241d-3bd2-49f1-b2b3-c4ad54cbcf05', 'ed236874-50e2-4985-a4b5-9e39a56380b5', 98, 4, 1, 105)
GO

--=========================================== Stored Procedures

/* =====================================================================
    Name: spCreateUser
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Creates a user with encrypted password
    Returns:
======================================================================== */
CREATE PROCEDURE spCreateUser
    @userEmail   VARCHAR(100),
    @userPassword   NVARCHAR(4000)
AS BEGIN
    INSERT INTO Users (userEmail, userPassword)
        VALUES (@userEmail, HASHBYTES('SHA2_512', @userPassword))
END
GO

/* =====================================================================
    Name: spLogin
    Author: G.Krynski
    Written: 4/11/20
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
    Name: spAddExercisePlan
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows Add operations to ExercisePlans
    Returns: message if the operation did not work,
             ExercisePlanId if operation did work
======================================================================== */
CREATE PROCEDURE spAddExercisePlan
    @userId     UNIQUEIDENTIFIER,
    @planName   VARCHAR(50),
    @planDate   DATETIME
AS BEGIN

    IF NOT EXISTS(SELECT NULL FROM Users WHERE userId = @userId ) BEGIN
        SELECT  [message] = 'User does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
        FOR JSON PATH
    END ELSE BEGIN
        DECLARE @ExercisePlanId UNIQUEIDENTIFIER = NEWID();

        INSERT INTO ExercisePlans(exercisePlanId, userId, planName, planDate) VALUES
            (@ExercisePlanId, @userId, @planName, @planDate)
        
        SELECT  [ExercisePlanId] = @ExercisePlanId,
                [message] = '',
                [success] = CAST(1 AS BIT),
                [errorCode] = 0
        FOR JSON PATH
    END
END
GO

/* =====================================================================
    Name: spAddExercise
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows Add operations to Exercises
    Returns: message if the operation did not work,
             ExerciserId if operation did work
======================================================================== */
CREATE PROCEDURE spAddExercise       
    @userId                 UNIQUEIDENTIFIER,     
    @exerciseName           VARCHAR(50), 
    @exerciseDescription    VARCHAR(50), 
    @exerciseVideoLink      VARCHAR(100) 
AS BEGIN 
    IF NOT EXISTS(SELECT NULL FROM Users WHERE userId = @userId ) BEGIN --Checks if userId exists. 
        SELECT  [message] = 'User does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
        FOR JSON PATH
    END ELSE BEGIN
        DECLARE @ExerciseId UNIQUEIDENTIFIER = NEWID();

        INSERT INTO Exercises (exerciseId, userId, exerciseName, exerciseDescription, exerciseVideoLink) VALUES
            (@ExerciseId, @userId, @exerciseName, @exerciseDescription, @exerciseVideoLink)
        
        SELECT  [ExerciseId] = @ExerciseId,
                [message] = '',
                [success] = CAST(1 AS BIT),
                [errorCode] = 0
        FOR JSON PATH
    END
END
GO

/* =====================================================================
    Name: spAddExercisePlanDetail
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows Add operations to ExercisePlanDetails
    Returns: message if the operation did not work,
             ExercisePlanDetailId if operation did work
======================================================================== */
CREATE PROCEDURE spAddExercisePlanDetail
    @exercisePlanId     UNIQUEIDENTIFIER,
    @exerciseId         UNIQUEIDENTIFIER,
    @weight             FLOAT,
    @countOf            INT,             
    @distance           FLOAT,           
    @timeInSeconds      INT             
AS BEGIN
    IF NOT EXISTS(SELECT NULL FROM ExercisePlans WHERE exercisePlanId = @exercisePlanId) BEGIN --Checks if exercisePlanId exists
         SELECT [message] = 'Exercise plan does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
         FOR JSON PATH
    END ELSE IF NOT EXISTS(SELECT NULL FROM Exercises WHERE exerciseId = @exerciseId) BEGIN --Checks if exerciseID exists
         SELECT [message] = 'Exercise does not exist',
                [success] = CAST(0 AS BIT),
                [errorCode] = 2
         FOR JSON PATH
    END ELSE BEGIN
        DECLARE @ExercisePlanDetailId UNIQUEIDENTIFIER = NEWID();

        INSERT INTO ExercisePlanDetails(exercisePlanDetailId,exercisePlanId, exerciseId, weight, countOf, distance, timeInSeconds) VALUES
            (@ExercisePlanDetailId, @exercisePlanId, @exerciseId, @weight, @countOf, @distance, @timeInSeconds)
        
        SELECT  [ExercisePlanDetailsId] = @ExercisePlanDetailId,
                [message] = '',
                [success] = CAST(1 AS BIT),
                [errorCode] = 0
        FOR JSON PATH
    END
END
GO

/* =====================================================================
    Name: spAddUser
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows Add operations to Users
    Returns: message if the operation did not work,
             UserId if operation did work
======================================================================== */
CREATE PROCEDURE spAddUser      
    @fName              VARCHAR(50),  
    @lName              VARCHAR(50), 
    @userEmail          VARCHAR(200),    
    @userPassword       VARBINARY(64),
    @gender             CHAR(1),
    @currentWeight      FLOAT
AS BEGIN
    IF EXISTS(SELECT NULL FROM Users WHERE userEmail = @userEmail) BEGIN --Checks if email is already in use
         SELECT [message] = 'Email is already in use',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
         FOR JSON PATH
    END ELSE BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER = NEWID();

        INSERT INTO Users(userId, fName, lName, userEmail, userPassword, gender, currentWeight) VALUES
            (@UserId, @fName, @lName, @userEmail, @userPassword, @gender, @currentWeight)
        
        SELECT  [UserId] = @UserId,
                [message] = '',
                [success] = CAST(1 AS BIT),
                [errorCode] = 0
        FOR JSON PATH
    END
END
GO

/* =====================================================================
    Name: spUpdateExercisePlan
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows update operations to ExercisePlans
    Returns: message if the operation did not work,
             ExercisePlanId if operation did work
======================================================================== */
CREATE PROCEDURE spUpdateExercisePlan
    @exercisePlanId     UNIQUEIDENTIFIER, 
    @userId             UNIQUEIDENTIFIER,
    @planName           VARCHAR(50),
    @planDate           DATETIME
AS BEGIN
    IF NOT EXISTS(SELECT NULL FROM ExercisePlans WHERE exercisePlanId = @exercisePlanId AND userId = @userId) BEGIN
        SELECT  [message] = 'Exercise plan does not exists',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
         FOR JSON PATH
    END ELSE BEGIN
        UPDATE ExercisePlans
        SET planName = @planName,
            planDate = @planDate
        WHERE exercisePlanId = @exercisePlanId
        
        SELECT @exercisePlanId AS exercisePlanId
    END
END 
GO

/* =====================================================================
    Name: spUpdateExercise
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows update operations to Exercises
    Returns: message if the operation did not work,
             exerciseId if operation did work
======================================================================== */
CREATE PROCEDURE spUpdateExercise
    @exerciseId             UNIQUEIDENTIFIER,
    @userId                 UNIQUEIDENTIFIER,     
    @exerciseName           VARCHAR(50), 
    @exerciseDescription    VARCHAR(50), 
    @exerciseVideoLink      VARCHAR(100) 
AS BEGIN
    IF NOT EXISTS(SELECT NULL FROM Exercises WHERE exerciseId = @exerciseId AND userId = @userId) BEGIN
        SELECT  [message] = 'Exercise does not exists',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
         FOR JSON PATH
    END ELSE BEGIN
        UPDATE Exercises
        SET exerciseName = @exerciseName,
            exerciseDescription = @exerciseDescription,
            exerciseVideoLink = @exerciseVideoLink
        WHERE exerciseId = @exerciseId
        
        SELECT @exerciseId AS exerciseId
    END
END 
GO

/* =====================================================================
    Name: spUpdateExercisePlanDetail
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows update operations to ExercisePlanDetails
    Returns: message if the operation did not work,
             exercisePlanDetailId if operation did work
======================================================================== */
CREATE PROCEDURE spUpdateExercisePlanDetail
    @ExercisePlanDetailId   UNIQUEIDENTIFIER,
    @exercisePlanId         UNIQUEIDENTIFIER,
    @exerciseId             UNIQUEIDENTIFIER,
    @weight                 FLOAT,
    @countOf                INT,             
    @distance               FLOAT,           
    @timeInSeconds          INT   
AS BEGIN
    IF NOT EXISTS(SELECT NULL FROM ExercisePlanDetails WHERE exercisePlanDetailId = @exercisePlanDetailId 
                        AND (exercisePlanId = @exercisePlanId AND exerciseid = @exerciseId)) BEGIN
        SELECT  [message] = 'ExercisePlanDetail does not exists',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
         FOR JSON PATH
    END ELSE BEGIN
        UPDATE ExercisePlanDetails
        SET weight = @weight,            
            countOf = @countOf,            
            distance = @distance,            
            timeInSeconds = @timeInSeconds       
        WHERE exercisePlanDetailId = @exercisePlanDetailId
        
        SELECT @exercisePlanDetailId AS exercisePlanDetailId
    END
END 
GO

/* =====================================================================
    Name: spUpdateUsers
    Author: G.Krynski
    Written: 4/11/20
    Purpose: Allows update operations to Users
    Returns: message if the operation did not work,
             userId if operation did work
======================================================================== */
CREATE PROCEDURE spUpdateUser
    @userId             UNIQUEIDENTIFIER,
    @fName              VARCHAR(50),  
    @lName              VARCHAR(50), 
    @userEmail          VARCHAR(200),    
    @userPassword       VARBINARY(64),
    @gender             CHAR(1),
    @currentWeight      FLOAT
AS BEGIN
    IF NOT EXISTS(SELECT NULL FROM Users WHERE userId = @userId) BEGIN
        SELECT  [message] = 'User does not exists',
                [success] = CAST(0 AS BIT),
                [errorCode] = 1
         FOR JSON PATH
    END ELSE BEGIN
        UPDATE Users
        SET userId = @userId,        
            fName = @fName,        
            lName = @lName,
            userEmail = @userEmail,       
            userPassword = @userPassword,    
            gender = @gender,         
            currentWeight = @currentWeight,  
        WHERE userId = @userId
        
        SELECT @userId AS userId
    END
END 
GO
