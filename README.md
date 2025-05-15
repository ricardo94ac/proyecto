# 🌐 Proyecto de Infraestructura Automatizada: Demon Slayer Web Servers

## 🧾 Descripción

Este proyecto implementa una infraestructura automatizada para levantar cinco servidores web, cada uno personalizado con una página HTML dedicada a un personaje de *Demon Slayer: Kimetsu no Yaiba*. La solución utiliza **Terraform** para el aprovisionamiento de instancias en AWS y OCI, y **Ansible** junto con **AWX** para configurar automáticamente los servidores y desplegar contenido temático personalizado.

---

## ⚙️ Tecnologías Utilizadas

- **Terraform**: aprovisionamiento de instancias EC2 en AWS y OCI.
- **Ansible**: automatización de configuración en los servidores.
- **AWX**: interfaz web para orquestar y ejecutar playbooks de Ansible.
- **Nginx**: servidor web instalado en cada instancia.
- **HTML/CSS**: contenido visual personalizado por personaje.
- **Bash**: script para generar inventario dinámico.

---

## 📁 Estructura del Proyecto

```bash
proyecto/
├── ansible/
│   ├── host_vars/              # Variables específicas por host
│   │   ├── web1.yml            # Contiene personaje asignado (ej: rengoku)
│   │   ├── web2.yml
│   │   ├── web3.yml
│   │   ├── web4.yml
│   │   └── web5.yml
│   ├── images/                 # Imágenes de los personajes
│   │   ├── inosuke.png
│   │   ├── muichiro.png
│   │   ├── rengoku.png
│   │   ├── tanjiro.png
│   │   └── tengen.jpg
│   └── playbook.yml            # Playbook principal para configurar servidores
├── ansible.cfg                 # Configuración de Ansible
├── generateinv.sh              # Script Bash para generar inventario
├── inventory.ini               # Inventario estático o generado
├── main.tf                     # Terraform para proveedor principal (AWS/OCI)
├── main.tf2                    # Terraform para segundo proveedor
├── terraform.tfstate           # Archivo de estado de Terraform
├── terraform.tfstate.backup    # Backup del estado de Terraform
