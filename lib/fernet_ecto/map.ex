defmodule Fernet.Ecto.Map do
  @moduledoc """
  An Ecto type for Fernet-encrypted maps.
  """
  use Ecto.Type

  import Fernet.Ecto.Type

  @doc """
  Fernet-encrypted data is stored as a binary in the database.
  """
  def type, do: :binary

  @doc """
  Only accept map values.
  """
  def cast(map) when is_map(map), do: {:ok, map}
  def cast(_), do: :error

  @doc """
  Encrypt a map to store in the database.
  """
  def dump(map) when is_map(map) do
    map
    |> :erlang.term_to_binary()
    |> encrypt()
  end

  @doc """
  Decrypt a map loaded from the database.
  """
  def load(ciphertext) do
    case decrypt(ciphertext) do
      {:ok, decrypted} -> {:ok, :erlang.binary_to_term(decrypted)}
      _ -> :error
    end
  end
end
