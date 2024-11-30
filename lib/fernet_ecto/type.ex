defmodule Fernet.Ecto.Type do
  @moduledoc false

  @encoded_key_length 44

  def encrypt(plaintext), do: encrypt(plaintext, key())

  defp encrypt(plaintext, key) when is_binary(key) do
    {:ok, _iv, ciphertext} = Fernet.generate(plaintext, key: key)
    {:ok, ciphertext}
  end

  defp encrypt(plaintext, [key | _]) do
    {:ok, _iv, ciphertext} = Fernet.generate(plaintext, key: key)
    {:ok, ciphertext}
  end

  def decrypt(ciphertext) do
    decrypt(ciphertext, key())
  end

  defp decrypt(_ciphertext, key) when byte_size(key) != @encoded_key_length do
    {:error, "malformed key"}
  end

  defp decrypt(ciphertext, key) when is_binary(key) do
    try do
      {:ok, Fernet.verify!(ciphertext, key: key, ttl: ttl(), enforce_ttl: enforce_ttl())}
    rescue
      RuntimeError -> {:error, "incorrect mac"}
    end
  end

  defp decrypt(_ciphertext, []) do
    {:error, "invalid key"}
  end

  defp decrypt(ciphertext, [key | rest]) do
    case decrypt(ciphertext, key) do
      {:ok, plaintext} -> {:ok, plaintext}
      {:error, "incorrect mac"} -> decrypt(ciphertext, rest)
      {:error, error} -> {:error, error}
    end
  end

  defp key(), do: Application.fetch_env!(:fernet_ecto, :key)
  defp ttl(), do: Application.get_env(:fernet_ecto, :ttl)
  defp enforce_ttl(), do: not is_nil(ttl())
end
