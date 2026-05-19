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
.\init-compose.ps1
```

O script clona os repositórios dos microsserviços, gera o arquivo `.env` com os caminhos locais e realiza o build das imagens. Ao final, suba o ambiente com:

```powershell
.\start-compose.ps1
```

Para gerar um token JWT, use o comando abaixo:

```powershell
.\new-token.ps1
```

## Serviços disponíveis

Todos os serviços são acessíveis através de [http://localhost:8080](http://localhost:8080).

| Serviço     | URL base       | Swagger                |
|-------------|----------------|------------------------|
| billing     | `/billing`     | `/billing/swagger`     |
| execution   | `/execution`   | `/execution/swagger`   |
| identity    | `/identity`    | `/identity/swagger`    |
| work-orders | `/work-orders` | `/work-orders/swagger` |

## Ferramentas

| Ferramenta     | URL                                            | Descrição                                                  |
|----------------|------------------------------------------------|------------------------------------------------------------|
| Mailpit        | [http://localhost:8081](http://localhost:8081) | Interface para inspecionar e-mails enviados pelos serviços |
| DynamoDB Admin | [http://localhost:8082](http://localhost:8082) | Interface para inspecionar tabelas DynamoDB                |

## Mock de microsserviços (WireMock)

Permite simular as respostas dos outros serviços a partir de arquivos JSON.

### Iniciando o servidor de mocks

```powershell
.\start-wiremock.ps1
```

O servidor sobe na porta `9091` e carrega automaticamente todos os arquivos da pasta `wiremock/`.

### Adicionando mapeamentos

Crie arquivos `.json` dentro da pasta `wiremock/`. Cada arquivo pode conter um ou mais stubs agrupados sob a chave `mappings`.

Exemplo — simulando o endpoint `GET /identity/users/{id}`:

```json
{
  "mappings": [
    {
      "name": "GET /identity/users/:id",
      "request": {
        "method": "GET",
        "urlPathPattern": "/identity/users/[^/]+"
      },
      "response": {
        "status": 200,
        "headers": { "Content-Type": "application/json" },
        "jsonBody": {
          "id": "00000000-0000-0000-0000-000000000001",
          "name": "Mecânico Teste",
          "cpfNumber": "12345678901",
          "role": "Mechanic"
        }
      }
    }
  ]
}
```

Salve o arquivo em `wiremock/identity.json` e reinicie o servidor para que o novo mapeamento seja carregado. A convenção adotada é um arquivo por microsserviço simulado.

A interface administrativa em [http://localhost:9091/__admin/mappings](http://localhost:9091/__admin/mappings) lista todos os stubs ativos e permite inspecioná-los sem reiniciar o container.

## Estrutura do projeto

```plain
├── docker-compose.yml
├── init-compose.ps1
├── start-compose.ps1
├── start-wiremock.ps1
├── new-token.ps1        # gera um token JWT
├── services.psd1        # lista de repositórios e configurações
├── local.psd1           # configurações locais, gerado pelo init-compose.ps1
├── .env                 # variáveis de ambiente, gerado pelo init-compose.ps1
├── localstack/          # scripts de inicialização do LocalStack
├── nginx/
│   ├── nginx.conf
│   └── index.html
└── wiremock/            # mapeamentos de stubs, um arquivo por microsserviço
```

## Links úteis

- [mechanics-billing](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-billing)
- [mechanics-execution](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-execution)
- [mechanics-identity](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-identity)
- [mechanics-work-orders](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-work-orders)
