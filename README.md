# Forward Selection with R-squared for Linear Regression in R

I needed to perform feature selection for a multivariate linear regression for a master's project. I decided to use forward selection with r-squared values as a selection criterion since the real objective of my project was to observe the shifts in Akaike Information Criterion (AIC) while the model complexity increased. If I performed the standard forward selection, I would have had little chances of going so overfit which was exactly what I needed to do to see the response of AIC. That is why I was after selecting features based solely on r-squared improvements. After a quick search, I realised there is no function of an R package which performs this. I wrote the function. I make it available here for use. For questions, please ping me at ozgurdoganbirol@gmail.com.

## Forward Selection

In many scenarios there are a high number of the predictors of a variable which we claim can be explained with a linear model. In that case, we need to find robust ways of selecting the best features. One of the best methods to do this is the forward selection. It is based on adding one feature to the model in each iteration, which has the best F-test significance results among others. Each iteration, the existing model is seperately fitted with each feature which is currently not in the model. The feature with best contribution is decided. The process is repeated. When none of the added features contribute to the model significantly, the process comes to an end.

## R-squared and AIC

In this work, the feature selection criterion is the highest r-squared contribution with a contribution threshold the user decides. This threshold tells the iteration to go on until the added features stop improving the r-squared score by the desired amount. The model calculates the AIC's of each fit in each iteration. If k is the number of parameters in the model, and L is the maximum likelihood of the model, the AIC is calculated as the following. 

> AIC = −2*ln(L) + 2*k  

As you can see as the likelihood increases, AIC decreases. By contrast, when the number of features in the model increases the value of AIC increases. This means that the AIC punishes the model for having more parameters which is source of complexity and possibly overfit. This is why, in comparison the lower the AIC is, the better. You could omit AIC part from the code, if that does not add value to your project.

## Explanation of Code and Pseudocode

The "forw_selc_R2" function takes data, maximum iterations the user like (limit of how many times the function needs to search for new features), and the improvement threshold for r-squared. The while loop on the outside wraps everything and stops only when no feature could not improve the r-squared score by at least the improvement threshold no more or it hits the maximum number of iterations. The inner for loop performs the forward selection. When a new model is decided, the outer while loop subjects the new model to the for loop again and again until it stops. The following pseudocode is a representation of the code.

```
forw_selc_R2<- function(data,predicted,max_iter,improvement_treshold){

	***Set the default states of the variables***
  
	while(completed==FALSE & iter_number<=max_iter){
		iter_number<-iter_number+1
		#Set iteration scores zero for new values.
		iteration_scores = 0
		for(i in 1:length(non_model_features) {
			model<-linear_regression(existing_features + non_model_features[i], data)
			iteration_scores = (non_model_features[i], model.R2, AIC(model))
		}
		iteration_scores=sort(R2, descending)
		if (iteration_scores[first_element,"R2"] > r2_current + improvement_treshold){
			existing_features.add(iteration_scores[first_element,”FeatureName”])
			non_model_features.drop(iteration_scores[first_element,”FeatureName”])
			R2_current= iteration_scores[1,”R2”]
			selected_models <- add_line(existing_features, R2_current,       iteration_scores[first_element,”AIC”])
		}
		#Unless the r-squared is improved as desired
		else{
			completed=TRUE
		}
		return(selected_models)
	}
}
```
## Final Comments

Please keep in mind that this function can perform up to n*(n+1)/2 multivariate linear regression fits for a dataset with n features. This can quickly become expensive. This code is not optimized. I suggest binary encoding of categorical variables as new features and normalization of continuous features before feeding the dataset into the model.
