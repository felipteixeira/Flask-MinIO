# Automação da aplicação Flask + MinIO

## Ferramentas utilizadas:
1. ###### [Docker](https://docs.docker.com/)
2. ###### Shell Script
3. ###### [Ansible](https://docs.ansible.com/ansible/latest/index.html) + AWS free-tier

## pré-requisitos: ##### Ansible

Para escrever a automação, utilizei dois repositórios privados no github.
Sendo eles: [automação](https://github.com/felipteixeira/instruct-auto.git) e
[minio_Uploader](https://github.com/felipteixeira/python)

Para executar a tarefa de automação, utilizei o ansible instalado em uma instância EC2 na AWS, apontando para o servidor da instruct.

No server Ansible, a partir do diretório **home/ubuntu**, execute git clone + [automação](https://github.com/felipteixeira/instruct-auto.git)

**PS:** Digite usuário e senha (permissão concedida ao usuário: instruct-selecao)

Ainda no Ansible, entre no path:
```bash
cd /instruct-auto
```
Caso esteja utilizando o known_hosts para conectar via SSH, via ansible, execute o playbook abaixo: 
```bash
ansible-playbook -i hosts playbook.yml 
```
Caso esteja utilizando senha, utilize o parametro -k e passe a senha quando solicitado para execução do playbook.
```bash
ansible-playbook -i hosts playbook.yml -k
```

Após finalizar as tarefas do playbook, teste os serviços abaixo. 
[aplicação](http://52.14.169.24:5000/) [MinIO](http://52.14.169.24:9000/)

Para logar no [MinIO](http://52.14.169.24:9000/) utilize **ACCESS_KEY/SECRET_KEY**
Ao logar, virique se dentro do **bucket-teste** existe o arquivo "fileToSendToMinIO" enviado pela automação.

#### Resumo da automação.

O arquivo [playbook.yml](https://github.com/felipteixeira/instruct-auto/blob/master/playbook.yml) contém descrito o step-by-step das tasks.

O arquivo [scripts.sh](https://github.com/felipteixeira/instruct-auto/blob/master/scripts.sh) executa o container docker MinIO, exporta as variáveis de ambiente,
instala as dependencias necessárias para aplicação funcionar e executa o servidor em modo daemon.

Em **files** e **templates** contém os arquivos necessários para o servidor target conseguir realizar o git clone no repositório privado da aplicação Flask utilizando chave SSH. 

# Deploy automático
## Ferramentas utilizadas:
1. ###### [Deploybot](https://deploybot.com/)
2. ###### [Ansible](https://docs.ansible.com/ansible/latest/index.html) + AWS free-tier

Para automatizar o deploy da aplicação em caso de alteração na branch master do repositório: [Minio_Uploader](https://github.com/felipteixeira/python) utilizei o [deploybot](https://deploybot.com/).

Ao receber uma nova versão do código, a ferramenta conecta via SSH no servidor Ansible e executa novamente o playbook: 
```bash
ansible-playbook -i hosts playbook.yml 
```
Assim o server da aplicação recebe a ultima versão do código. 












