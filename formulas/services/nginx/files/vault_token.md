root@vps-bd085347:/home/debian# vault operator init
Unseal Key 1: G4Ea8tKrJqTXtx2D5NeqCBReW1mdKXCMmwqwTU7dQ0JU
Unseal Key 2: 4CowYql/AgsS+BkDAcqoL1EMbT6yQ+Fj1Wbe4yWezJ9D
Unseal Key 3: nsyLCtPTVVVt1I+LSji9FDbDolsQPpvLX8EGUk+O1KDO
Unseal Key 4: XHq9Dp52iCf+Bkn5FgtkCgT6GYvP25X4JgdWMJgob4fo
Unseal Key 5: bESdjqt42SaqDaX27yS3CMUS/ruHM1dqXlEdAw7KrSFm

Initial Root Token: s.FHgpOOTfMz4FYbAdNLOdt3XX

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.