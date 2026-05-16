# Mechanics Local

Ambiente de desenvolvimento local para o projeto FIAP Mechanics. Sobe todos os microsserviços, bancos de dados e ferramentas de apoio em containers Docker, com um único ponto de entrada via Nginx.

## Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)

## Configuração inicial

### Permissão de execução de scripts

No Windows, a execução de scripts PowerShell vem desabilitada por padrão. Abra um terminal como administrador e execute:

```powershell
Set-ExecutionPolicy Unrestricted
```

### Inicialização

Execute o script de inicialização na raiz do projeto:

```powershell
.\init.ps1
```

O script clona os repositórios dos microsserviços, gera o arquivo `.env` com os caminhos locais e realiza o build das imagens. Ao final, suba o ambiente com:

```powershell
docker compose up -d
```

## Serviços disponíveis

Todos os serviços são acessíveis através de [http://localhost:8080](http://localhost:8080).

| Serviço | URL base | Swagger |
|---|---|---|
| billing | `/billing` | `/billing/swagger` |
| execution | `/execution` | `/execution/swagger` |
| identity | `/identity` | `/identity/swagger` |
| work-orders | `/work-orders` | `/work-orders/swagger` |

## Ferramentas

| Ferramenta | URL | Descrição |
|---|---|---|
| DynamoDB Admin | [http://localhost:8082](http://localhost:8082) | Interface para inspecionar tabelas DynamoDB |
| Mailpit | [http://localhost:8081](http://localhost:8081) | Interface para inspecionar e-mails enviados pelos serviços |

## Estrutura do projeto

```plain
├── docker-compose.yml
├── init.ps1
├── services.psd1        # lista de repositórios e configurações
├── local.psd1           # configurações locais, gerado pelo init.ps1
├── .env                 # variáveis de ambiente, gerado pelo init.ps1
├── localstack/          # scripts de inicialização do LocalStack
└── nginx/
    ├── nginx.conf
    └── index.html
```

## Links úteis

- [mechanics-billing](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-billing)
- [mechanics-execution](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-execution)
- [mechanics-identity](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-identity)
- [mechanics-work-orders](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-work-orders)
