---
title: "Final Project"
author: "Gina Krynski"
date: "5/4/2022"
output: 
  html_document:
    keep_md: true
---




## Data cleaning and preparation

```r
set.seed(05042022)
stellar_obj <- read.csv("star_classification.csv")
stellar_obj <- stellar_obj %>% mutate(class = as.factor(class)) %>% filter(u != -9999)


## Removing ID and date variables:
stellar_obj <- stellar_obj %>% dplyr::select(alpha, delta, u, g, r, i, z, class, redshift)

## Taking random sample
stellar_sample <- sample_n(stellar_obj, size = 10000)

## Splitting into training and testing sets
trainIndex <- sample(1:nrow(stellar_sample), nrow(stellar_sample) * .80)
stellarTraining <- stellar_sample[trainIndex,]
stellarTesting <- stellar_sample[-trainIndex,]
```

## EDA 

### Using Random Forest to look at variable importance

```r
stellar_forest <- train(class ~. , 
                     data = stellarTraining,
                     importance = T,
                     method="rf",
                     trControl=trainControl("oob"),
                     ntree=100)
stellar_forest
```

```
## Random Forest 
## 
## 8000 samples
##    8 predictor
##    3 classes: 'GALAXY', 'QSO', 'STAR' 
## 
## No pre-processing
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy  Kappa    
##   2     0.973750  0.9531123
##   5     0.975875  0.9567915
##   8     0.975000  0.9552409
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was mtry = 5.
```

```r
varImp(stellar_forest, scale=FALSE)
```

```
## rf variable importance
## 
##   variables are sorted by maximum importance across the classes
##           GALAXY     QSO    STAR
## redshift 112.753 153.019 379.476
## u         14.404  20.675   6.338
## g         14.850  15.996   5.370
## z          9.529   8.995   4.258
## i          7.457   5.927   4.133
## r          6.268   6.733   3.883
## delta      6.339  -2.713   0.527
## alpha      5.814  -1.256   2.900
```

```r
plot(varImp(stellar_forest, scale=FALSE))
```

![](StellarObjectModeling_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

## More Exploratory Plots

```r
ggplot(stellar_sample, aes(x=u, y=redshift, color=class)) +
  geom_point() +
  theme_bw() + 
  labs(title="Redshift vs U")
```

![](StellarObjectModeling_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
ggplot(stellar_sample, aes(x=u, y=g, color=class)) +
  geom_point() +
  theme_bw() + 
  labs(title="G vs U")
```

![](StellarObjectModeling_files/figure-html/unnamed-chunk-3-2.png)<!-- -->

```r
ggplot(stellar_sample, aes(x=u, y=z, color=class)) +
  geom_point() +
  theme_bw() + 
  labs(title="Z vs U ")
```

![](StellarObjectModeling_files/figure-html/unnamed-chunk-3-3.png)<!-- -->

```r
ggplot(stellar_sample, aes(x=u, y=delta, color=class)) +
  geom_point() +
  theme_bw() + 
  labs(title="Delta vs U")
```

![](StellarObjectModeling_files/figure-html/unnamed-chunk-3-4.png)<!-- -->
## Model 1: LDA

```r
# Train the model
lda_mod <- train(class ~ ., data=stellarTraining, method="lda",
                trControl=trainControl(method="cv",number=5),
                         preProcess = c("center", "scale"))
print(lda_mod)
```

```
## Linear Discriminant Analysis 
## 
## 8000 samples
##    8 predictor
##    3 classes: 'GALAXY', 'QSO', 'STAR' 
## 
## Pre-processing: centered (8), scaled (8) 
## Resampling: Cross-Validated (5 fold) 
## Summary of sample sizes: 6400, 6400, 6400, 6400, 6400 
## Resampling results:
## 
##   Accuracy  Kappa   
##   0.843875  0.703177
```

```r
# Test predictions
stellarTesting$pred_class_lda <- predict(lda_mod, newdata=stellarTesting)

# Misclassification rate
misclass_rate_lda <- mean(stellarTesting$pred_class_lda != stellarTesting$class)
```


## Model 2: PLS Classification

```r
pls_mod <- plsr <- train(class ~ .,
                   data=stellarTraining,
                   method="pls", 
                   preProcess=c("center", "scale"),
                   trControl = trainControl(method="cv", 5),
                   tuneGrid=data.frame(ncomp=1:8)) 
print(pls_mod)
```

```
## Partial Least Squares 
## 
## 8000 samples
##    8 predictor
##    3 classes: 'GALAXY', 'QSO', 'STAR' 
## 
## Pre-processing: centered (8), scaled (8) 
## Resampling: Cross-Validated (5 fold) 
## Summary of sample sizes: 6400, 6399, 6400, 6401, 6400 
## Resampling results across tuning parameters:
## 
##   ncomp  Accuracy   Kappa    
##   1      0.6932511  0.3332526
##   2      0.7540012  0.4791227
##   3      0.8112525  0.6348300
##   4      0.8165019  0.6467125
##   5      0.8248764  0.6658573
##   6      0.8305022  0.6760826
##   7      0.8272525  0.6699093
##   8      0.8281274  0.6714887
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was ncomp = 6.
```

```r
# Test predictions
stellarTesting$pred_class_pls <- predict(pls_mod, newdata=stellarTesting)

# Misclassification rate
misclass_rate_pls <- mean(stellarTesting$pred_class_pls != stellarTesting$class)
```

## Model 3: Random Forest

```r
random_forest_model <- train(class~.,
                   data=stellarTraining,
                   method="rf",
                   trControl=trainControl("oob"), 
                   tuneGrid=data.frame(mtry=1:10),
                   ntree=200) 

random_forest_model
```

```
## Random Forest 
## 
## 8000 samples
##    8 predictor
##    3 classes: 'GALAXY', 'QSO', 'STAR' 
## 
## No pre-processing
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy  Kappa    
##    1    0.965375  0.9380453
##    2    0.973500  0.9527084
##    3    0.974750  0.9548436
##    4    0.976750  0.9583624
##    5    0.976125  0.9572470
##    6    0.975875  0.9567994
##    7    0.975125  0.9554524
##    8    0.975250  0.9556806
##    9    0.974750  0.9547892
##   10    0.975250  0.9556887
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was mtry = 4.
```

```r
# Test predictions
stellarTesting$pred_class_rf <- predict(random_forest_model, newdata=stellarTesting)

# Misclassification rate
misclass_rate_rf <- mean(stellarTesting$pred_class_rf != stellarTesting$class)
```

## Model 4:Support Vector Classifier

```r
svc <- train(class ~.,
             data=stellarTraining,
             method="svmLinear",
             trControl=trainControl("cv", number=5),
             tuneGrid=data.frame(C=c(0.1,1,10)))


svc$bestTune
```

```
##    C
## 3 10
```

```r
print(svc)
```

```
## Support Vector Machines with Linear Kernel 
## 
## 8000 samples
##    8 predictor
##    3 classes: 'GALAXY', 'QSO', 'STAR' 
## 
## No pre-processing
## Resampling: Cross-Validated (5 fold) 
## Summary of sample sizes: 6400, 6400, 6401, 6399, 6400 
## Resampling results across tuning parameters:
## 
##   C     Accuracy   Kappa    
##    0.1  0.9368742  0.8867802
##    1.0  0.9486247  0.9087554
##   10.0  0.9577497  0.9244716
## 
## Accuracy was used to select the optimal model using the largest value.
## The final value used for the model was C = 10.
```

```r
# Test predictions
stellarTesting$pred_class_svc <- predict(svc, newdata=stellarTesting)

# Misclassification rate
misclass_rate_svc <- mean(stellarTesting$pred_class_svc != stellarTesting$class)
```

## Model Comparison

```r
Model <- c("LDA", "PLS Classification", "Random Forest", "SVC")
Missclassification <- c(misclass_rate_lda, misclass_rate_pls, misclass_rate_rf, misclass_rate_svc)
model_comparison <- data_frame(Model, Missclassification)
model_comparison %>% kbl() %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Model </th>
   <th style="text-align:right;"> Missclassification </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> LDA </td>
   <td style="text-align:right;"> 0.1460 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> PLS Classification </td>
   <td style="text-align:right;"> 0.1690 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Random Forest </td>
   <td style="text-align:right;"> 0.0240 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SVC </td>
   <td style="text-align:right;"> 0.0345 </td>
  </tr>
</tbody>
</table>

## Final Model Description

```r
random_forest_model$finalModel
```

```
## 
## Call:
##  randomForest(x = x, y = y, ntree = 200, mtry = min(param$mtry,      ncol(x))) 
##                Type of random forest: classification
##                      Number of trees: 200
## No. of variables tried at each split: 4
## 
##         OOB estimate of  error rate: 2.38%
## Confusion matrix:
##        GALAXY  QSO STAR class.error
## GALAXY   4718   64    7  0.01482564
## QSO       115 1429    1  0.07508091
## STAR        3    0 1663  0.00180072
```







