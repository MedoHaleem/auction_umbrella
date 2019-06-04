defmodule AuctionTest do
  import Ecto.Query
  use ExUnit.Case
  alias Auction.{Item, Repo}
  doctest Auction

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "list_items/0" do
    setup  do
      {:ok, item1} = Repo.insert(%Item{title: "Item 1"})
      {:ok, item2} = Repo.insert(%Item{title: "Item 2"})
      {:ok, item3} = Repo.insert(%Item{title: "Item 3"})
      %{items: [item1, item2, item3]}
    end

    test "returns all Items in the database", %{items: items} do
      assert items == Auction.list_items
    end
  end

  describe "insert_item/1" do
    test "adds an Item to the database" do
      count_query = from i in Item, select: count(i.id)
      before_count = Repo.one(count_query)
      {:ok, _item} = Auction.insert_item(%{title: "test item"})
      assert Repo.one(count_query) == before_count + 1
    end

    test "the Item in the database has the attributes provided" do
      attrs = %{title: "test item", description: "test description"}
      {:ok, item} = Auction.insert_item(attrs)
      assert item.title == attrs.title
      assert item.description == attrs.description
    end

    test "it returns an error on error" do
      assert {:error, _changeset} = Auction.insert_item(%{foo: :bar})
    end
  end

end
