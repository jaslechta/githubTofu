# Vault namespaces with OpenTofu

Repo pro sprĂˇvu Vault namespace pomocĂ­ OpenTofu a GitHub Actions.

## Struktura

- `LAB/` - samostatnĂˇ konfigurace prostĹ™edĂ­ LAB
- `TDA/` - samostatnĂˇ konfigurace pro TDA Vault
- `PRO/` - samostatnĂˇ konfigurace pro PRO Vault
- `modules/namespace/` - spoleÄŤnĂ˝ modul pro vytvoĹ™enĂ­ namespace

KaĹľdĂ© prostĹ™edĂ­ je samostatnĂ˝ root module. Namespace definice jsou v `namespace/*.yaml`.

## Jak to funguje

- V kaĹľdĂ©m prostĹ™edĂ­ jsou YAML soubory v `namespace/`.
- `locals.tf` je naÄŤte pomocĂ­ `fileset()` a `yamldecode()`.
- `main.tf` pĹ™es `for_each` zavolĂˇ modul `../modules/namespace`.
- GitHub Actions spouĹˇtĂ­ OpenTofu vĹľdy jen v konkrĂ©tnĂ­ sloĹľce prostĹ™edĂ­.
