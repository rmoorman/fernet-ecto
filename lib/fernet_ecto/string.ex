defmodule Fernet.Ecto.String do
  @moduledoc """
  An Ecto type for Fernet-encrypted strings.
  """
  use Ecto.Type

  import Fernet.Ecto.Type

  @doc """
  Fernet-encrypted data is stored as a binary in the database.
  """
  def type, do: :binary

  @doc """
  Only accept binary and string plaintext values.
  """
  def cast(plaintext) when is_binary(plaintext), do: {:ok, plaintext}
  def cast(_), do: :error

  @doc """
  Encrypt a value to store in the database.
  """
  def dump(plaintext), do: encrypt(plaintext)

  @doc """
  Decrypt a value loaded from the database.
  """
  def load(ciphertext) do
    case decrypt(ciphertext) do
      {:ok, plaintext} -> {:ok, plaintext}
      _ -> :error
    end
  end
end
