test_that("get_bls_refweek() returns BLS payroll reference week", {
  expect_equal(get_bls_refweek(2023, 2023)[1], lubridate::interval('2023-01-08', '2023-01-14', tz='UTC'))
})
