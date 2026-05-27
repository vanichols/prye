#' Combine six metrics into one summary
#'
#' @param trtdat One of the field's xxxx_trtkey (e.g. sexy1_trtkey, eusun1_trtkey).
#' @param plotdat One of the field's xxxx_plotkey (e.g. sexy1_plotkey, eusun1_plotkey)
#' @returns A data frame
#' @export


GetDesiredFormat <- function(trtdat = sexy1_trtkey,
                             plotdat = sexy1_plotkey){

  simp_data <-
    sexy1_plotkey |>
    left_join(sexy1_trtkey |> select(trt_name, trt_id)) |>
    separate(trt_id, into = c("field_id", "sea_name", "trt_name"), sep = "_") |>
    select(sea_name, field_id, block, plot, trt_name) |>
    mutate(plot = as.character(plot))

  return(simp_data)

}
