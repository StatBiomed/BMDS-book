
# Load data
dat_dir = "https://github.com/StatBiomed/scRNA-efficiency-prediction/raw/refs/heads/main/data/"
X_dat = read.csv(paste0(dat_dir, "/features/humanproteincode_octamer_gene_level.csv"))
y_dat = read.csv(paste0(dat_dir, "/estimated/sck562_all_dynamical_beta_gamma.csv"))

# Merge data into dataframe
merged_df <- merge(y_dat, X_dat, by = "gene_id")
df = merged_df[, c(4, 6:ncol(merged_df))]
rownames(df) = merged_df$gene_name

# Fit linear regression
res_lm = lm(fit_beta ~ ., data=df)
summary(res_lm)

y_pred = predict(res_lm, df)
plot(df$fit_beta, y_pred, main=paste("R^2=", round(cor(df$fit_beta, y_pred)^2, 3)))
plot(df$AAAAGUCC, df$fit_beta)


# Train and test split
set.seed(0)
n_samples = nrow(df)
idx_train = sample(n_samples, size = 0.75 * n_samples, replace = FALSE)
df_train = df[idx_train, ]
df_test  = df[-idx_train, ]


# Model 1: using all features
res_lm1 = lm(fit_beta ~ ., data=df_train)
y_test1 = predict(res_lm1, df_test)

plot(df_test$fit_beta, y_test1, main=paste("R^2=", round(cor(df_test$fit_beta, y_test1)^2, 3)))


# Transform data
# df[, 1] = log10(df[, 1] + 0.001)
# df[, 2:ncol(df)] = log10(df[, 2:ncol(df)] + 1e-7)
df_train[, 1] = log10(df_train[, 1] + 0.001)
df_train[, 2:ncol(df_train)] = log10(df_train[, 2:ncol(df_train)] + 1e-7)
df_test[, 1] = log10(df_test[, 1] + 0.001)
df_test[, 2:ncol(df_test)] = log10(df_test[, 2:ncol(df_test)] + 1e-7)

# Model 1: using all features
res_lm1 = lm(fit_beta ~ ., data=df_train)
y_test1 = predict(res_lm1, df_test)

plot(df_test$fit_beta, y_test1, main=paste("R^2=", round(cor(df_test$fit_beta, y_test1)^2, 3)))


# Model 2: using significant features
coef_lm1 = summary(res_lm1)$coefficients[-1, ]
sig_features = rownames(coef_lm1)[coef_lm1[, "Pr(>|t|)"] < 0.1]
sig_features

formula2 = as.formula(paste("fit_beta ~", paste(sig_features, collapse= " + ")))
res_lm2 = lm(formula2, data=df_train)
y_test2 = predict(res_lm2, df_test)

plot(df_test$fit_beta, y_test2, main=paste("R^2=", round(cor(df_test$fit_beta, y_test2)^2, 3)))

