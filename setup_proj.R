

usethis::create_package("~/Projects/rSINS")

# setup_project
usethis::proj_activate(".")

# ignore
usethis::use_build_ignore(c(
  "update_version.sh",
  "Makefile",
  "src/",
  "setup_proj.R",
  "README.html",
  "init.r"
))

# use pkg
usethis::use_package("tictoc")
usethis::use_package("DBI")
usethis::use_package("RSQLite")
usethis::use_package("ggplot2")
usethis::use_package("dplyr")
usethis::use_package("purrr")
usethis::use_package("assertthat")

# suggested

# remotes

# import from
usethis::use_package_doc()
usethis::use_import_from("grDevices", c("colorRampPalette", "dev.off", "pdf", "png"))
usethis::use_import_from("methods", "is")
usethis::use_import_from("utils", "head")
usethis::use_import_from("rlang", "abort")
usethis::use_import_from("dplyr", "%>%")

usethis::use_readme_md()


usethis::use_testthat()
usethis::use_test("rSINS")
usethis::use_gpl_license()
