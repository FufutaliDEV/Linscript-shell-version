# Linscript-shell-version
Versão otimizada e leve para uso exclusivo no terminal, sem dependências gráficas.

Este é o script linscriptshell.sh – a versão de linha de comando do nosso conjunto de ferramentas de gerenciamento de pacotes, focada em sistemas que utilizam o gerenciador de pacotes APT.

⚠️ Compatibilidade Crítica
Diferente da nossa Edição Zenity, que pode funcionar em diversas distros desde que o Zenity esteja instalado, a Edição Shell Pura inclui uma verificação rigorosa para garantir que o sistema seja baseado em Debian (como Chrome OS Flex, Crostini, Ubuntu, etc.).

Foco Principal: Sistemas que usam o gerenciador de pacotes APT.

Vantagem: Extrema leveza e não requer a instalação de nenhum pacote de interface gráfica (como Zenity).

⚙️ Funcionalidades
O script oferece um menu interativo baseado em texto para executar as tarefas de manutenção:

Instalar Aplicativo: Tenta a instalação e oferece uma busca detalhada de sugestões no terminal se o pacote não for encontrado.

Desinstalar Aplicativo: Remove pacotes com confirmação, oferecendo busca por nomes de pacotes instalados.

Atualizar o Sistema: Executa sudo apt update e sudo apt upgrade para manter seu sistema em dia.

🚀 Instalação Rápida
Utilize o Instalador Flexível para obter esta versão de forma rápida:

Para Usuários do Instalador Flexível:
Ao executar o Linscript-Instalador-Flex.sh, selecione a opção "SHELL" no menu. O instalador fará o download desta versão, garantirá que você tenha a dependência curl e criará um atalho que abre o terminal.

Para Uso Direto (Download e Execução):
Se você já estiver em um sistema Debian e quiser usar o script imediatamente:

Baixe o Script RAW:

Bash

curl -sLf https://gist.githubusercontent.com/FufutaliDEV/a3f0644994e39d78a9e9c40e5b788e24/raw/31288c9a54e1fafc3f95c6c2a1629e0f5f1c0401/linscriptshell.sh -o linscript.sh
Dê Permissão e Execute:

Bash

chmod +x linscript.sh
./linscript.sh
