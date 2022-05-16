
#' @export
peak_db <- function(
  db_dir
)
{
  requireNamespace("DBI")
  requireNamespace("RSQLite")
  requireNamespace("assertthat")

  # go to dir, check if dbs exist
  assertthat::assert_that(dir.exists(db_dir))

  db_files <- list.files(db_dir,pattern=".db",full.names=TRUE)

  assertthat::assert_that(length(db_files) > 0)

  # only peaking the first one
  db_f <- db_files[1]
  db_con <- DBI::dbConnect(RSQLite::SQLite(), dbname=db_f)

  db_tbls <- DBI::dbListTables(db_con)
  db_fields <- purrr::map(db_tbls,function(tbls){
    DBI::dbListFields(db_con, tbls)
  })
  names(db_fields) <- db_tbls

  DBI::dbDisconnect(db_con)
  return(list(db_tables=db_tbls, db_fields=db_fields))
}
