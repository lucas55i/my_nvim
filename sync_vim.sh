#!/bin/bash


ARQUIVO_ORIGEM="/Users/macbookair/.config/nvim/init.vim"
DIRETORIO_DESTINO="/Users/macbookair/Dev/setup/my_nvim/"
DIRETORIO_OLD="$DIRETORIO_DESTINO/old"

NOME_ARQUIVO=$(basename "$ARQUIVO_ORIGEM")
TIMESTAMP=$(date +"%y%m%d_%H%M%S")
MENSAGEM="Atualização automática - ${NOME_ARQUIVO%.txt}_$TIMESTAMP.txt"

if [ ! -f "$ARQUIVO_ORIGEM" ]; then
    echo "Erro: o arquivo '$ARQUIVO_ORIGEM' não existe."
    exit 1
fi

if [ ! -d "$DIRETORIO_OLD" ]; then
    echo "'$DIRETORIO_OLD' não existe."
    echo "Criando diretório de arquivos antigos..."
    mkdir -p "$DIRETORIO_OLD"
fi

if [ ! -d "$DIRETORIO_DESTINO" ]; then
    echo "O diretório de destino não existe. Criando..."
    mkdir -p "$DIRETORIO_DESTINO"
fi

if [ -f "$DIRETORIO_DESTINO/$NOME_ARQUIVO" ]; then
    echo "Arquivo existente encontrado. Movendo o antigo para '$DIRETORIO_OLD'..."
    mv "$DIRETORIO_DESTINO/$NOME_ARQUIVO" "$DIRETORIO_OLD/${NOME_ARQUIVO%.txt}_$TIMESTAMP.txt"
fi

cp "/Users/macbookair/Dev/setup/sync_vim.sh" "$DIRETORIO_DESTINO"
cp "$ARQUIVO_ORIGEM" "$DIRETORIO_DESTINO"

if [ $? -eq 0 ]; then
    echo "Arquivo copiado com sucesso para '$DIRETORIO_DESTINO'."
else
    echo "Falha ao copiar o arquivo."
    exit 1
fi 

sleep 1

echo "Ativando SSH local para chave github"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
ssh -T git@github.com


sleep 2
echo "Realizando commit e push para o github."
cd $DIRETORIO_DESTINO

git add .
git status
git commit -m "$MENSAGEM"
git push

echo "✅ Commit realizado com a mensagem: " 
         echo "'$MENSAGEM'" > README.md

