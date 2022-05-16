

#' @export
make_adegenet <- function(
  db_dir,
  zome_id
)
{
  if(length(zome_id) > 1){zome_str <- paste(zome_id,collapse=", ")
  }else{ zome_str <- zome_id}
  # query for data as adegenet
  ade_q <- paste0("SELECT individualid, ",zome_str,", demex, demey, generation FROM sinsdata")

  res <- get_sins_res(db_dir=db_dir,query=ade_q)

  res <- res %>% purrr::map(function(tbl){
    tbl <- tbl %>%
      dplyr::mutate(pop_name=paste0("pop_",demex,"-",demey)) %>%
      dplyr::select(individualid,dplyr::all_of(zome_id),demex,demey,pop_name,generation)
    return(tbl)
  })
  return(res)
}
