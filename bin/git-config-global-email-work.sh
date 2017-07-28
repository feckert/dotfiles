#!/bin/sh

git config --global user.email fe@dev.tdt.de
git config --global sendemail.smtpserver mail.dev.tdt.de
git config --global sendemail.smtpserverport 25
git config --global sendemail.smtpuser fe@dev.tdt.de
git config --global sendemail.smtpencryption tls

#sendemail.smtpsslcertpath=/home/feckert/maildevtdtde.crt
