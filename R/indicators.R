#' Live indicators and the profiles and domains they belong to
#'
#' Outputs a data frame of indicators within a profile or domain
#' @return A data frame of indicators within a profile or domain.
#' @param ProfileID Numeric vector, id of profiles of interest
#' @param DomainID Numeric vector, id of domains of interest
#' @examples
#' \dontrun{
#' # Returns a complete data frame of indicators and their domains and profiles
#' indicators()
#'
#' # Returns a data frame of all of the indicators in the Public Health Outcomes Framework
#' indicators(ProfileID = 19)}
#' @import dplyr
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content set_config config
#' @family lookup functions
#' @seealso \code{\link{area_types}} for area type  and their parent mappings,
#'   \code{\link{indicator_metadata}} for indicator metadata and
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{category_types}} for category lookups and
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups and
#'   \code{\link{indicators_unique}} for unique indicatorids and their names
#' @export

indicators <- function(ProfileID = NULL,
                       DomainID = NULL) {
        path <- "https://fingertips.phe.org.uk/api/"
        set_config(config(ssl_verifypeer = 0L))
        if (!is.null(ProfileID)){
                tempdf <- profiles(ProfileID = ProfileID)
                if (!is.null(DomainID)) warning("DomainID is ignored as ProfileID has also been entered")
                DomainID <- tempdf$DomainID
        } else if (!is.null(DomainID)) {
                tempdf <- profiles()
                DomainID <- DomainID
        } else {
                tempdf <- profiles()
                DomainID <- tempdf$DomainID
        }
        df <- DomainID %>%
                lapply(function(dom) {
                        dfRaw <- paste0(path,"indicator_metadata/by_group_id?group_ids=",dom) %>%
                                GET %>%
                                content("text") %>%
                                fromJSON(flatten = TRUE)
                        if (length(dfRaw) != 0){
                                dfRaw <- unlist(dfRaw, recursive = FALSE)
                                dfIDs <- dfRaw[grepl("IID", names(dfRaw))]
                                names(dfIDs) <- gsub(".IID","",names(dfIDs))
                                dfDescription <- unlist(dfRaw[grepl("Descriptive", names(dfRaw))],
                                                        recursive = FALSE)
                                dfDescription <- dfDescription[grepl("NameLong", names(dfDescription))]
                                names(dfDescription) <- gsub(".Descriptive.NameLong","",names(dfDescription))
                                commonNames <- intersect(names(dfIDs), names(dfDescription))
                                dfIDs <- dfIDs[commonNames]
                                dfDescription <- dfDescription[commonNames]

                                data.frame(IndicatorID = unlist(dfIDs),
                                           IndicatorName = unlist(dfDescription),
                                           DomainID = dom,
                                           row.names=NULL) %>%
                                        mutate(IndicatorName = as.character(IndicatorName))
                        }
                }) %>%
                bind_rows %>%
                mutate(IndicatorName = factor(IndicatorName))
        df <- left_join(df, tempdf, by = c("DomainID" = "DomainID")) %>%
                select(IndicatorID, IndicatorName,
                       DomainID, DomainName,
                       ProfileID, ProfileName) %>%
                as_tibble
        return(df)
}

#' Live indicators
#'
#' Outputs a data frame of indicators (their id and name only). Note, this
#' function can take up to a few minutes to run (depending on internet
#' connection speeds)
#' @return A data frame of indicator ids and names
#' @inheritParams indicators
#' @examples
#' indicators_unique(ProfileID = 21)
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicators and their parent domains and
#'   profiles, \code{\link{area_types}} for area type  and their parent
#'   mappings, \code{\link{indicator_metadata}} for indicator metadata and
#'   \code{\link{profiles}} for profile lookups and
#'   \code{\link{deprivation_decile}} for deprivation decile lookups and
#'   \code{\link{category_types}} for category lookups and
#'   \code{\link{indicator_areatypes}} for indicators by area types lookups
#' @export
indicators_unique <- function(ProfileID = NULL,
                            DomainID = NULL) {
        df <- indicators(ProfileID, DomainID)
        df <- unique(df[,c("IndicatorID", "IndicatorName")])
        return(df)

}
