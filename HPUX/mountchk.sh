#!/usr/bin/sh

mount |awk '{print $1}'|sort -n > mount.date.last
