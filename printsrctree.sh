# /bin/bash

# Usage: printjavasrctree src-root-dir project-name file-extension exclude-dir
#
# Acha todos os arquivos terminados com .$file-extension (p.ex go java c) abaixo de src-root-dir e
# gera um arquivo chamado project-name.pdf com a concatenacao de todos os arquivos encontrados
# caso queria excluir algum diretorio, indicar no parâmetro exclude-dir

if [ $# -ne 4 ]; then
	echo "Usage: $0 src-root-dir project-name file-extension exclude-dir"
	exit
fi

root_dir_path=$1
project_name=$2
file_extension=$3
exclude_dir=$4

rm -f /tmp/source.md
find -L $root_dir_path -name \*.$file_extension | grep -v "${exclude_dir}" > /tmp/print-files

while IFS= read -r file_path; do
	file_name=`basename $file_path`
	echo $file_name >> /tmp/source.md
	echo "\`\`\`{include="$file_path" .go .numberLines}" >> /tmp/source.md
	echo "\`\`\`" >> /tmp/source.md
done < /tmp/print-files

pandoc --standalone --lua-filter=`pwd`/include-code-files.lua --output /tmp/output.html --metadata title="$project_name" /tmp/source.md
cat /tmp/output.html | wkhtmltopdf -T 20 -B 20 -L 20 -R 20 - $project_name.pdf

rm /tmp/print-files /tmp/source.md /tmp/output.html
