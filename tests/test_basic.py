from src.add import add


def test_basic_addition():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
