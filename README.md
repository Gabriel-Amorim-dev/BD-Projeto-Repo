# BD-Projeto-Repo
-----

# 📚 README: Projeto de Modelagem de Banco de Dados - Histórico Escolar

Este projeto implementa o modelo de dados para o **Exercício 1 (Histórico Escolar)**, aplicando o processo de normalização (até a 3FN) e utilizando recursos avançados de SQL como Chaves Estrangeiras (FKs) e Colunas Geradas.

-----

## 1\. ⚙️ Modelo de Dados e Normalização

O modelo foi normalizado para eliminar redundâncias e garantir a integridade referencial, resultando em cinco entidades interconectadas.

### 1.1. Estrutura das Entidades

| Tabela | Função | Chave Primária (PK) | Relações (FKs) |
| :--- | :--- | :--- | :--- |
| **CURSO** | Informações sobre o curso. | `Cod_Curso` | - |
| **PROFESSOR** | Cadastro dos docentes. | `Cod_Professor` | - |
| **DISCIPLINA** | Cadastro das disciplinas. | `Cod_Disciplina` | - |
| **ALUNO** | Dados cadastrais do aluno. | `Matricula` | `Cod_Curso` (referência a CURSO) |
| **HISTORICO** | Relacionamento N:N entre Aluno, Disciplina e Professor. | `(Matricula, Cod_Disciplina)` | `Matricula`, `Cod_Disciplina`, `Cod_Professor` |

### 1.2. Conceitos-Chave Utilizados

  * **Chaves Estrangeiras (FK):** Garantem que um registro no `HISTORICO` só possa apontar para um `ALUNO`, `DISCIPLINA` e `PROFESSOR` que realmente existem, prevenindo o `Error Code: 1452`.
  * **Colunas Geradas (`GENERATED ALWAYS AS`):** Automatizam regras de negócio e eliminam a necessidade de preenchimento manual, prevenindo o `Error Code: 1136`.
      * `Situacao` (em `HISTORICO`): Calculada automaticamente com base na `Nota`.
      * `Atividade` (em `ALUNO`): Calculada automaticamente com base no `Is_Ativo` (Status Booleano).

-----

## 2\. 🚀 Como Executar o Script

O script `Script SQL Completo do Projeto` cria todas as tabelas, define as chaves e insere os dados do Exercício 1.

1.  Abra seu cliente SQL (MySQL Workbench, DBeaver, etc.).
2.  Copie e cole o [Script SQL Completo do Projeto](https://www.google.com/search?q=%23-script-sql-completo-do-projeto-exerc%C3%ADcio-1) (localizado ao final da nossa conversa).
3.  Execute o script na íntegra.

**Atenção:** Se você já tinha tabelas similares criadas, pode ser necessário deletá-las (`DROP TABLE NOME_TABELA;`) antes de executar o script novamente.

-----

## 3\. 🔎 Consultas Principais

### A. Consulta do Histórico Completo (INNER JOIN)

Para visualizar o histórico completo do aluno, incluindo os **nomes** (que não estão armazenados no `HISTORICO`), usamos o `INNER JOIN`:

```sql
SELECT
    A.Nome_Aluno,
    A.Atividade AS Status_Aluno,
    D.Nome_Disciplina,
    P.Nome_Professor,
    H.Nota,
    H.Faltas,
    H.Situacao
FROM
    HISTORICO H
INNER JOIN ALUNO A ON H.Matricula = A.Matricula
INNER JOIN DISCIPLINA D ON H.Cod_Disciplina = D.Cod_Disciplina
INNER JOIN PROFESSOR P ON H.Cod_Professor = P.Cod_Professor
WHERE
    H.Matricula = '007043';
```

### B. Visualizar Dados Brutos

Para verificar se os dados foram inseridos corretamente nas tabelas-pai:

```sql
SELECT * FROM ALUNO;
SELECT * FROM HISTORICO; -- Verifique se a coluna 'Situacao' foi preenchida!
```

-----

## 4\. 📝 Dicionário de Dados Completo

Este dicionário descreve a estrutura de todas as tabelas normalizadas do projeto Histórico Escolar.

### Tabela: ALUNO

| Tabela | Coluna | Tipo de Dado | Observação | Contexto | Nulidade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ALUNO** | `Matricula` | `VARCHAR(10)` | **PK** (Chave Primária). | *Identificador único do aluno no sistema.* | **NÃO PODE SER NULO** |
| **ALUNO** | `Nome_Aluno` | `VARCHAR(100)` | - | *Nome completo do aluno cadastrado.* | **NÃO PODE SER NULO** |
| **ALUNO** | `Cod_Curso` | `VARCHAR(10)` | **FK** (Chave Estrangeira), referenciando `CURSO`. | *Código do curso em que o aluno está cadastrado. Garante integridade referencial.* | **PODE SER NULO** |
| **ALUNO** | `Is_Ativo` | `TINYINT(1)` | Status booleano (1=Ativo/Regular, 0=Inativo/Não Regular). | *Indica o status primário e operacional do aluno na universidade.* | **NÃO PODE SER NULO** |
| **ALUNO** | `Atividade` | `VARCHAR(25)` | **Gerada** automaticamente, baseada no valor de `Is_Ativo`. | *Descrição textual do status do aluno ('Regular' ou 'Não Regular').* | **NÃO PODE SER NULO** |

<br>

### Tabela: CURSO

| Tabela | Coluna | Tipo de Dado | Observação | Contexto | Nulidade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CURSO** | `Cod_Curso` | `VARCHAR(10)` | **PK** (Chave Primária). | *Código único que identifica o curso (ex: 0037).* | **NÃO PODE SER NULO** |
| **CURSO** | `Nome_Curso` | `VARCHAR(100)` | - | *Nome completo do curso (ex: Análise de Sistemas).* | **NÃO PODE SER NULO** |

<br>

### Tabela: PROFESSOR

| Tabela | Coluna | Tipo de Dado | Observação | Contexto | Nulidade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **PROFESSOR** | `Cod_Professor` | `VARCHAR(10)` | **PK** (Chave Primária). | *Código único que identifica o professor (ex: 001).* | **NÃO PODE SER NULO** |
| **PROFESSOR** | `Nome_Professor` | `VARCHAR(100)` | - | *Nome completo do professor.* | **NÃO PODE SER NULO** |

<br>

### Tabela: DISCIPLINA

| Tabela | Coluna | Tipo de Dado | Observação | Contexto | Nulidade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **DISCIPLINA** | `Cod_Disciplina` | `VARCHAR(10)` | **PK** (Chave Primária). | *Código único que identifica a disciplina (ex: AN001).* | **NÃO PODE SER NULO** |
| **DISCIPLINA** | `Nome_Disciplina` | `VARCHAR(100)` | - | *Nome completo da disciplina (ex: Análise de sistemas).* | **NÃO PODE SER NULO** |

<br>

### Tabela: HISTORICO

| Tabela | Coluna | Tipo de Dado | Observação | Contexto | Nulidade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **HISTORICO** | `Matricula` | `VARCHAR(10)` | **PK** (Parte da Chave Composta) e **FK** referenciando `ALUNO`. | *Liga o registro de histórico ao aluno.* | **NÃO PODE SER NULO** |
| **HISTORICO** | `Cod_Disciplina` | `VARCHAR(10)` | **PK** (Parte da Chave Composta) e **FK** referenciando `DISCIPLINA`. | *Liga o registro de histórico à disciplina cursada.* | **NÃO PODE SER NULO** |
| **HISTORICO** | `Cod_Professor` | `VARCHAR(10)` | **FK** referenciando `PROFESSOR`. | *Professor que ministrou a disciplina naquele registro.* | **PODE SER NULO** |
| **HISTORICO** | `Nota` | `DECIMAL(4, 2)` | - | *Nota final obtida pelo aluno na disciplina.* | **PODE SER NULO** |
| **HISTORICO** | `Faltas` | `INT` | - | *Número de faltas registradas na disciplina.* | **PODE SER NULO** |
| **HISTORICO** | `Situacao` | `VARCHAR(20)` | **Gerada** ('Aprovado' se Nota \>= 7.0, 'Reprovado' caso contrário). | *Status final da disciplina, calculado pela regra de negócio.* | **NÃO PODE SER NULO** |
