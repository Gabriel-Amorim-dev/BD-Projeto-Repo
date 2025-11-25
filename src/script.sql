-- -----------------------------------------------------------
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- -----------------------------------------------------------

CREATE DATABASE IF NOT EXISTS HistoricoEscolar;
USE HistoricoEscolar;

-- -----------------------------------------------------------
-- 2. CRIAÇÃO E MODELAGEM DAS TABELAS (DDL)
-- -----------------------------------------------------------

-- 1. Tabela PROFESSOR (Pai)
CREATE TABLE PROFESSOR (
    Cod_Professor VARCHAR(10) PRIMARY KEY,
    Nome_Professor VARCHAR(100) NOT NULL
);

-- 2. Tabela DISCIPLINA (Pai)
CREATE TABLE DISCIPLINA (
    Cod_Disciplina VARCHAR(10) PRIMARY KEY,
    Nome_Disciplina VARCHAR(100) NOT NULL
);

-- 3. Tabela CURSO (Pai)
CREATE TABLE CURSO (
    Cod_Curso VARCHAR(10) PRIMARY KEY,
    Nome_Curso VARCHAR(100) NOT NULL
);

-- 4. Tabela ALUNO (Filho de CURSO)
CREATE TABLE ALUNO (
    Matricula VARCHAR(10) PRIMARY KEY,
    Nome_Aluno VARCHAR(100) NOT NULL,
    Cod_Curso VARCHAR(10),
    Is_Ativo TINYINT(1) NOT NULL, -- 1=Ativo (Regular), 0=Inativo (Não Regular)
    
    -- Coluna Gerada: Exibe o status do aluno (Regular/Não Regular)
    Atividade VARCHAR(25) GENERATED ALWAYS AS (
        CASE
            WHEN Is_Ativo = 1 THEN 'Regular'
            ELSE 'Não Regular'
        END
    ) STORED,
    
    -- Chave Estrangeira: Referencia a tabela CURSO
    FOREIGN KEY (Cod_Curso) REFERENCES CURSO(Cod_Curso)
);

-- 5. Tabela HISTORICO (Tabela de Relacionamento N:N)
CREATE TABLE HISTORICO (
    Matricula VARCHAR(10),
    Cod_Disciplina VARCHAR(10),
    Cod_Professor VARCHAR(10),
    
    Nota DECIMAL(4, 2),
    Faltas INT,
    
    -- Coluna Gerada: Calcula automaticamente a Situação com base na Nota
    Situacao VARCHAR(20) GENERATED ALWAYS AS (
        CASE
            WHEN Nota >= 7.0 THEN 'Aprovado'
            ELSE 'Reprovado'
        END
    ) STORED,

    -- Chave Primária Composta
    PRIMARY KEY (Matricula, Cod_Disciplina),

    -- Chaves Estrangeiras
    FOREIGN KEY (Matricula) REFERENCES ALUNO(Matricula),
    FOREIGN KEY (Cod_Disciplina) REFERENCES DISCIPLINA(Cod_Disciplina),
    FOREIGN KEY (Cod_Professor) REFERENCES PROFESSOR(Cod_Professor)
);

-- -----------------------------------------------------------
-- 3. INSERÇÃO DE DADOS EXEMPLO (DML)
-- -----------------------------------------------------------

-- Inserir Tabela CURSO
INSERT INTO CURSO (Cod_Curso, Nome_Curso) VALUES
('0037', 'Análise de Sistemas');

-- Inserir Tabela PROFESSOR
INSERT INTO PROFESSOR (Cod_Professor, Nome_Professor) VALUES
('001', 'Roberto Carlos'),
('002', 'Jandira'),
('003', 'Junior Villas');

-- Inserir Tabela DISCIPLINA
INSERT INTO DISCIPLINA (Cod_Disciplina, Nome_Disciplina) VALUES
('AN001', 'Análise de sistemas'),
('MA002', 'Matemática'),
('IN101', 'Inglês');

-- Inserir Tabela ALUNO (Aluno do Exercício 1)
INSERT INTO ALUNO (Matricula, Nome_Aluno, Cod_Curso, Is_Ativo) VALUES
('007043', 'Victor Alexandre Costa', '0037', 1); -- Is_Ativo=1 gera Atividade='Regular'

-- Inserir Tabela HISTORICO (Omitindo a coluna Situacao)
INSERT INTO HISTORICO (Matricula, Cod_Professor, Cod_Disciplina, Nota, Faltas)
VALUES
    ('007043', '001', 'AN001', 7.5, 7), 
    ('007043', '002', 'MA002', 8.0, 4), 
    ('007043', '003', 'IN101', 4.5, 0);

-- -----------------------------------------------------------
-- 4. CONSULTA DE VERIFICAÇÃO (Histórico Completo)
-- -----------------------------------------------------------

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
