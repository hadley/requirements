context("test-code.R")

test_that("doesn't find packages when not present", {
  expect_equal(req_code(1), character())
  expect_equal(req_code(x), character())
  expect_equal(req_code(library()), character())
  expect_equal(req_code(function(x, y) {}), character())
})

test_that("finds explicit package loading calls", {
  expect_equal(req_code(library(x)), "x")
  expect_equal(req_code(library("x")), "x")
  expect_equal(req_code(require(x)), "x")
  expect_equal(req_code(requireNamespace("x")), "x")
  expect_equal(req_code(loadNamespace("x")), "x")
})

test_that("handle character.only correctly", {
  expect_equal(req_code(library(x, char = TRUE)), character())
  expect_equal(req_code(library(x, character.only = TRUE)), character())
  expect_equal(req_code(library("x", character.only = TRUE)), "x")
})

test_that("find namespace qualifiers", {
  expect_equal(req_code(x::foo), "x")
  expect_equal(req_code(x:::foo), "x")
  expect_equal(req_code(x::foo(x)), "x")
  expect_equal(req_code(x:::foo(x)), "x")
})

test_that("can find multiple packages", {
  expect_equal(req_code({x::f; x::f}), "x")
  expect_equal(req_code({x::f; y::f}), c("x", "y"))
  expect_equal(req_code(function(x = x::f, y = y::f) {}), c("x", "y"))
})

test_that("can work with expressions", {
  x1 <- expression()
  expect_equal(req_code(!!x1), character())

  x2 <- expression(x::f(0), y::f(1))
  expect_equal(req_code(!!x2), c("x", "y"))
})

