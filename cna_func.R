install.packages("reticulate")
require(reticulate)

## This function is used to add new columns to the exsited dataframe
labelling <- function(df, condition, newname){
  sub <- subset(df, eval(parse(text = condition)))
  sub_vec <- as.vector(rownames(sub))
  label_vec <- rep(0, nrow(df))
  for (i in 1:length(label_vec)){
    if (i %in% sub_vec & df[i, 'used'] != 1){
      label_vec[i] <- 1
      df[i, 'used'] = 1
    }
  }
  df[newname] <- label_vec
  return(df)
}

## This function is used to extract the first solution of the cna, return is a condition
CNA <- function(df, aim, a, b){
  cnares <- cna(df, con = a, cov = b, outcome = c(aim))
  cnalist <- cnares$solution
  cnacondlist <- get(aim, cnalist)
  return(cnacondlist$asf[1,2])
}

## This function is used to parse the outcome, the input is a condition
myparse <- function(cnares){
  cnares <- as.list(strsplit(cnares, "")[[1]])
  equal_list <- which(cnares == "=")
  and_list <- which(cnares == "*")
  or_list <- which(cnares == "+")
  cnares <- replace(cnares, equal_list, "==")
  cnares <- replace(cnares, and_list, "&")
  cnares <- replace(cnares, or_list, "|")
  return(paste(cnares, collapse = ''))
}


## Given a dataframe and the cutoff t, and the outcome we want to get
rca <- function(df, t, outcome){
  df_copy <- df
  df_copy$used <- rep(0, nrow(df))
  count <- 1
  state <- TRUE
  while(state){
    cond <- CNA(df, aim = outcome, a = t, b = 0.1)
    if (is.null(cond)){
      break
    }
    cond_parsed <- myparse(cond)
    df_copy <- labelling(df_copy, cond_parsed, sprintf("c%d", count))
    df <- subset(df, !(eval(parse(text = cond_parsed))))
    count <- count + 1
  }
  return(df_copy)
}


cna_data_main <- rca(cna_data, 0.9, "J=3")
cna_data_main <- cna_data
labelling(cna_data_main, cna_data_main$A == 2, "c1")
cna_data_main$c1 <- ifelse(cna_data_main$A == 2, 1, 0)
cna(cna_data, con = 0.9, cov = 0.1, outcome = c("J=3"))
