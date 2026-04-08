# Vault namespaces with OpenTofu

Repo pro sprĂˇvu Vault Enterprise namespaces pomocĂ­ OpenTofu a GitHub Actions.

## Architektura

- LAB, TDA, PRO jsou samostatnĂ© root moduly
- LDAP auth je centralizovanĂ˝ v root namespace danĂ© Vault instance
- AD/LDAP skupiny jsou mapovanĂ© na root external identity groups
- V child namespaces se tvoĹ™Ă­ internal identity groups s namespace-specific policies
- Namespaces jsou typu:
  - dev/my-app
  - int/my-app
  - acc/my-app

## Struktura

- `LAB/` - konfigurace LAB instance
- `TDA/` - konfigurace TDA instance
- `PRO/` - konfigurace PRO instance
- `modules/namespace/` - spoleÄŤnĂ˝ modul pro child namespace, KV, policies a internal groups
- `namespace/*.yaml` - popis aplikacĂ­ a pĹ™Ă­stupĹŻ per environment

## PoznĂˇmka

Tento scaffold pĹ™edpoklĂˇdĂˇ Vault Enterprise s namespaces a provider hashicorp/vault.
PĹ™ed prvnĂ­m apply ovÄ›Ĺ™ kompatibilitu resource argumentĹŻ s verzĂ­ provideru, kterou pouĹľĂ­vĂˇte internÄ›.