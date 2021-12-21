
#' @export
get_sins_res <- function(
  db_dir,
  query=NULL,
  params=NULL
){
  requireNamespace("dplyr")
  requireNamespace("purrr")
  requireNamespace("DBI")
  requireNamespace("RSQLite")
  requireNamespace("assertthat")

  # go to dir, check if dbs exist
  assertthat::assert_that(dir.exists(db_dir))

  db_files <- list.files(db_dir,pattern=".db",full.names=TRUE)

  assertthat::assert_that(length(db_files) > 0)

  # load and query each db
  res_list <- purrr::map(
    db_files,
    function(db_f, qq, pp){
      db_con <- DBI::dbConnect(RSQLite::SQLite(), dbname=db_f)

      # fetch and return results in a list, one entry for each db
      if(!is.null(pp)){
        a_query <- DBI::dbSendQuery(db_con, qq, params=pp)
      }else{
        a_query <- DBI::dbSendQuery(db_con, qq)
      }
      res <- DBI::dbFetch(a_query)
      DBI::dbClearResult(a_query)
      DBI::dbDisconnect(db_con)
      return(res)
    },
    qq = query,
    pp = params
  )

  return(res_list)
}

