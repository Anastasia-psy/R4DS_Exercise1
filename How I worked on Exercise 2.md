To understand what termplot(.) plots
-----------------------------------

manual of predict() function for Linear models:
https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.lm.html

Some notes:
predict(mod1, type = "terms") DO NOT evaluates predictions of the response variable, but of the regression terms b1*X1 and b2*X2 plus a constant (I don't know what this constant stands for, but there it is). 
So, termplot(mod1, ask = FALSE, ylim = "free") makes 2 plots (one for each regression term) where on the x-axis there are the x1 and x2 "true" values, while on the y-axis there are the values given by the estimated coefficients b1 and b2 multiplied by x1 and x2 respectively (b1*X1 and b2*X2) plus the above-mentioned constant that I don't know what stands for (if you wnat to see the constant just run the function predict() as stated above). 
Then the resulting plots are of the following sort:  b1*X1+const ~ x1 and b2*X2+const ~ x2.



Commands in debug mode to remember
----------------------------------
“n” to execute the next command
“s” to step into the next function
“f” to finish the current loop or function
“c” to continue execution normally
“Q” to stop the function and return to the console




How I worked on the debugging
-----------------------------
Since the termplot() function is defined in a base package (stats), I cannot use the browser() call directly into the function definition. Then, I used the debug() function that automatically sets up a browser() call at the beginning of the termplot() function so that I can enter into the debug mode in this way.



Understanding how termplot() works (inside debug mode)
-----------------------------------
NB. I will write how it works in our particular case (i.e. with the arguments and options we specified)

1. tms <- terms <- matrix of 2 columns, each of them contains the estimated values of the regression terms (b1*X1+const and b2*X2+const explained above)
2. n.tms <- number of columns of terms
3. transform.x <- vector (FALSE, FALSE)
4. data <- mf <- dataframe of y, x1, I(1:n)
5. nmt <- colnames of tms
6. THIS IS THE REASON WHY R PRINTS THE Warning message: if (any(grepl(":", nmt, fixed = TRUE))) warning("'model' appears to involve interactions: see the help page", 
    domain = NA, immediate. = TRUE)
	What's happening: grepl(":", x, ...) finds out if there is any ":" in x, and 		here we have one in the column names =I(1:n)


... I skip unimportant things such as titles and labels...


7. The second problem is here: 

xx <- carrier(cn[[i]], transform.x[i])
      if (!is.null(use.rows)) 
        xx <- xx[use.rows]
      xlims <- range(xx, na.rm = TRUE)
      if (rug) 
        xlims[1L] <- xlims[1L] - 0.07 * diff(xlims)
      oo <- order(xx)
      plot(xx[oo], tms[oo, i], type = "l", xlab = xlabs[i], 
        ylab = ylabs[i], xlim = xlims, ylim = ylims, 
        main = main[i], col = col.term, lwd = lwd.term, 
        ...)