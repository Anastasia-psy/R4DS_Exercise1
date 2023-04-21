set.seed(1)
n <- 10L
x1 <- rnorm(n)
x2 <- seq.int(n)
beta0 <- 0; beta1 <- 1; beta2 <- 2
y <- beta0 + beta1 * x1 + beta2 * x2 + rnorm(n)

(mod1 <- lm(y ~ x1 + x2))
termplot(mod1, ask = FALSE, ylim = "free")

(mod2 <- lm(y ~ x1 + I(1:n)))

debug(termplot)
termplot(mod2, ask = FALSE, ylim = "free")

undebug(termplot)