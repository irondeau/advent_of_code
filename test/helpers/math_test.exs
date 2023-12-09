defmodule AdventOfCodeTest.Helpers.MathTest do
  use ExUnit.Case, async: true

  import AdventOfCode.Helpers.Math

  test "gcd" do
    assert 1 = gcd(5, 9)
    assert 4 = gcd(12, 20)
    assert 4 = gcd(-12, 20)
    assert 4 = gcd(-12, -20)
    assert 4 = gcd(0, 4)
    assert 0 = gcd(0, 0)

    assert 4 = gcd([8, 12, 20])

    assert_raise ArithmeticError, fn ->
      gcd([8, 12, :a])
    end
  end

  test "lcm" do
    assert 6 = lcm(2, 3)
    assert 4 = lcm(2, 4)
    assert 4 = lcm(-2, 4)
    assert 4 = lcm(-2, -4)
    assert 0 = lcm(0, 4)
    assert 0 = lcm(0, 0)

    assert 300 = lcm([12, 15, 75])

    assert_raise ArithmeticError, fn ->
      lcm([12, :a, 75])
    end
  end

  test "quadratic" do
    assert [1.0, -5.0] = quadratic(2, 8, -10)
    assert [-5.0, -1.0] = quadratic(-1, -6, -5)
    assert 2.0 = quadratic(1, -4, 4)
    assert nil == quadratic(1, 0, 1)

    assert_raise ArithmeticError, fn ->
      quadratic(:a, -6, -5)
    end

    assert_raise FunctionClauseError, fn ->
      quadratic(-1, :a, -5)
    end

    assert_raise ArithmeticError, fn ->
      quadratic(-1, -6, :a)
    end
  end
end
