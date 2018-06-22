context("test-code.R")

test_that("doesn't find packages when not present", {
  expect_equal(find_pkgs(1), character())
  expect_equal(find_pkgs(x), character())
  expect_equal(find_pkgs(library()), character())
  expect_equal(find_pkgs(function(x, y) {}), character())
})

test_that("finds explicit package loading calls", {
  expect_equal(find_pkgs(library(x)), "x")
  expect_equal(find_pkgs(library("x")), "x")
  expect_equal(find_pkgs(require(x)), "x")
  expect_equal(find_pkgs(requireNamespace(x)), "x")
  expect_equal(find_pkgs(loadNamespace(x)), "x")
})

test_that("handle character.only correctly", {
  expect_equal(find_pkgs(library(x, char = TRUE)), character())
  expect_equal(find_pkgs(library(x, character.only = TRUE)), character())
  expect_equal(find_pkgs(library("x", character.only = TRUE)), "x")
})

test_that("find namespace qualifiers", {
  expect_equal(find_pkgs(x::foo), "x")
  expect_equal(find_pkgs(x:::foo), "x")
})

test_that("can find multiple packages", {
  expect_equal(find_pkgs({x::f; x::f}), "x")
  expect_equal(find_pkgs({x::f; y::f}), c("x", "y"))
  expect_equal(find_pkgs(function(x = x::f, y = y::f) {}), c("x", "y"))
})

