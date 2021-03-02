defmodule MyApp.LogTest do
  use MyApp.DataCase

  alias MyApp.Log

  # describe "entries" do
  #   alias MyApp.Log.Entry

  #   @valid_attrs %{note: "some note", subject: "elixir", update_allowed: true}
  #   @update_attrs %{note: "some updated note", subject: "elixir", update_allowed: false}
  #   @invalid_attrs %{note: nil, subject: nil, update_allowed: nil}

  #   def entry_fixture(attrs \\ %{}) do
  #     {:ok, entry} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Log.create_entry()

  #     entry
  #   end

  #   test "list_entries/0 returns all entries" do
  #     entry = entry_fixture()
  #     assert Log.list_entries() == [entry]
  #   end

  #   test "get_entry!/1 returns the entry with given id" do
  #     entry = entry_fixture()
  #     assert Log.get_entry!(entry.id) == entry
  #   end

  #   test "create_entry/1 with valid data creates a entry" do
  #     assert {:ok, %Entry{} = entry} = Log.create_entry(@valid_attrs)
  #     assert entry.note == "some note"
  #     assert entry.update_allowed == true
  #   end

  #   test "create_entry/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Log.create_entry(@invalid_attrs)
  #   end

  #   test "update_entry/2 with valid data updates the entry" do
  #     entry = entry_fixture()
  #     assert {:ok, %Entry{} = entry} = Log.update_entry(entry, @update_attrs)
  #     assert entry.note == "some updated note"
  #     assert entry.update_allowed == false
  #   end

  #   test "update_entry/2 with invalid data returns error changeset" do
  #     entry = entry_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Log.update_entry(entry, @invalid_attrs)
  #     assert entry == Log.get_entry!(entry.id)
  #   end

  #   test "delete_entry/1 deletes the entry" do
  #     entry = entry_fixture()
  #     assert {:ok, %Entry{}} = Log.delete_entry(entry)
  #     assert_raise Ecto.NoResultsError, fn -> Log.get_entry!(entry.id) end
  #   end

  #   test "change_entry/1 returns a entry changeset" do
  #     entry = entry_fixture()
  #     assert %Ecto.Changeset{} = Log.change_entry(entry)
  #   end
  # end

  describe "sync" do
    alias MyApp.Log.Entry

    @valid_attrs %{note: "some note", subject: "elixir"}
    @update_attrs %{note: "some updated note", subject: "elixir"}
    @invalid_attrs %{note: nil, subject: nil}

    test "sync_entry/2 inserts new entries for new subjects" do
      assert entry = Log.sync_entry(@valid_attrs)
      assert entry.note == "some note"
    end

    test "sync_entry/2 updates existing entries with same subject" do
      assert entry_one =
               Log.sync_entry(%{
                 note: "ecto 1",
                 subject: "ecto"
               })

      assert entry_one.note == "ecto 1"

      assert entry_two =
               Log.sync_entry(%{
                 note: "ecto 2",
                 subject: "ecto"
               })

      assert entry_two.note == "ecto 2"
    end

    test "sync_entry/2 does not update existing entries with same subject when update not allowed" do
      assert entry_one =
               Log.sync_entry(%{
                 note: "phoenix 1",
                 subject: "phoenix",
                 update_allowed: false
               })

      assert entry_one.note == "phoenix 1"

      # (Ecto.StaleEntryError) attempted to insert a stale struct
      # when an on_conflict returns 0 row affected ecto errors out
      # https://elixirforum.com/t/handling-upsert-stale-error/34734/4
      assert entry_two =
               Log.sync_entry(%{
                 note: "phoenix 2",
                 subject: "phoenix",
                 update_allowed: false
               })

      # not updated
      assert entry_two.note == "phoenix 1"
    end
  end
end
