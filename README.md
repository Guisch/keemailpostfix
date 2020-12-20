# Keemail Postfix

Never expose your personal email again

- [Keemail Postfix](#keemail-postfix)
  * [About / Synopsis](#about---synopsis)
  * [Installation](#installation)
    + [Docker](#docker)
    + [Basic Install](#basic-install)
      - [DNS](#dns)
      - [Env](#env)
      - [Requirements](#requirements)
      - [Migration](#migration)
  * [Credit](#credit)



## About / Synopsis

Keemail Postfix is the mailserver part of Keemail. It's using Postfix.

* Keemail allows you to easily generate aliases to your personal email address
* Provide a REST API to let you integrate it into your favorite tools
* Aliases are randomly generated but can be customized

## Installation

Keemail Postfix needs [Keemail Server](https://github.com/Guisch/keemailserver) to be installed in order to work. See the main [Keemail](https://github.com/Guisch/keemail) repo for a full detailed guides.



### Docker

You can automate deployment with Docker. Please visit the main [Keemail](https://github.com/Guisch/keemail) repo for a full detailed guide.



### Basic Install

#### DNS

You need to own a domain and create an MX redirection where Keemail Postfix will be hosted.





#### Env

You need to set environment variables

| Name           | Required / Optional | Description                             |
| -------------- | ------------------- | --------------------------------------- |
| MYSQL_USER     | Required            | Database user (try avoiding using root) |
| MYSQL_PASSWORD | Required            | Database Password                       |
| MYSQL_HOST     | Required            | Database Hostname                       |
| MYSQL_DB       | Required            | Database name                           |
| DOMAIN         | Required            | Alias email domain                      |



#### Requirements

The script needs postfix 3.2 or later to work, the postfix-mysql library and a mysql-client. For example, on Ubuntu run:

```bash
$ apt install postfix postfix-mysql mysql-client
```



#### Migration

Make sure [Keemail Server](https://github.com/Guisch/keemailserver) is running and that migration has been done (i.e. MYSQL_DB exists). Configure postfix via the script

``````bash
$ chmod +x assets/postfix.sh
$ ./assets/postfix.sh
``````

Then restart postfix



## Credit

This repo is based from https://github.com/MartinPesek/Postfix-Forwarding