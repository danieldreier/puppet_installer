#!/bin/bash

# exists COMMAND
exists() {
  if type "$1" >/dev/null 2>&1
  then
    echo "found $1"
    return 0
  else
    return 1
  fi
}

unable_to_retrieve_package() {
  echo "Unable to retrieve a valid package!"
  exit 1
}

download() {
  echo "downloading $1"
  echo "  to file $2"

  if [ -e "$2" ]
  then
    echo "Error: File $2 already exists"
    return 1
  fi

  if exists wget; then
    wget_download "$1" "$2" && return 0
  fi

  if exists curl; then
    curl_download "$1" "$2" && return 0
  fi

  if exists perl; then
    perl_download "$1" "$2" && return 0
  fi

  if exists python; then
    python_download "$1" "$2" && return 0
  fi

  if exists ruby; then
    ruby_download "$1" "$2" && return 0
  fi

  if exists bash; then
    bash_download "$1" "$2" && return 0
  fi

  unable_to_retrieve_package
}

# validate_download FILE
validate_download() {
  if [ -s "$1" ] && [ -f "$1" ]
  then
    return 0
  else
    return 1
  fi
}

# curl_download URL FILENAME
curl_download() {
  echo "trying curl..."
  curl --output "$2" "$1" || return 1
  validate_download "$2" || return 1
  return 0
}

# wget_download URL FILENAME
wget_download() {
  echo "trying wget..."
  wget --output-document "$2" "$1" || return 1
  validate_download "$2" || return 1
  return 0
}

# python_download URL FILENAME
python_download() {
  echo "trying python..."
  python -c "import sys,urllib2 ; sys.stdout.write(urllib2.urlopen(sys.argv[1]).read())" "$1" > "$2" 2>/tmp/stderr
  rc=$?
  # check for 404
  grep "HTTP Error 404" /tmp/stderr 2>&1 >/dev/null
  if test $? -eq 0; then
    echo "ERROR 404"
    unable_to_retrieve_package
  fi

  # check for bad return status or empty output
  if test $rc -ne 0 || test ! -s "$2"; then
    return 1
  fi
  return 0

  validate_download "$2" || return 1
  return 0
}

# perl_download URL FILENAME
perl_download() {
  echo "trying perl..."
  perl -e 'use LWP::Simple; getprint($ARGV[0]);' "$1" > "$2" 2>/tmp/stderr
  rc=$?
  # check for 404
  grep "404 Not Found" /tmp/stderr 2>&1 >/dev/null
  if test $? -eq 0; then
    echo "ERROR 404"
    unable_to_retrieve_package
  fi

  # check for bad return status or empty output
  if test $rc -ne 0 || test ! -s "$2"; then
    return 1
  fi

  validate_download "$2" || return 1

  return 0
}

# ruby_download URL FILENAME
ruby_download() {
  ruby -e "require 'open-uri'; File.open('$2', 'w') do |file| file.write(open('$1').read) end"
  validate_download "$2" || return 1
  return 0
}

bash_download() {
  [ -n "$BASH" ] || return 1
  # pretty epic bashism, copied verbatim from
  # http://unix.stackexchange.com/questions/83926/how-to-download-a-file-using-just-bash-and-nothing-else-no-curl-wget-perl-et
  function __wget() {
      : ${DEBUG:=0}
      local URL=$1
      local tag="Connection: close"
      local mark=0

      if [ -z "${URL}" ]; then
          printf "Usage: %s \"URL\" [e.g.: %s http://www.google.com/]" \
                "${FUNCNAME[0]}" "${FUNCNAME[0]}"
          return 1;
      fi
      read proto server path <<<$(echo ${URL//// })
      DOC=/${path// //}
      HOST=${server//:*}
      PORT=${server//*:}
      [[ x"${HOST}" == x"${PORT}" ]] && PORT=80
      [[ $DEBUG -eq 1 ]] && echo "HOST=$HOST"
      [[ $DEBUG -eq 1 ]] && echo "PORT=$PORT"
      [[ $DEBUG -eq 1 ]] && echo "DOC =$DOC"

      exec 3<>/dev/tcp/${HOST}/$PORT
      echo -en "GET ${DOC} HTTP/1.1\r\nHost: ${HOST}\r\n${tag}\r\n\r\n" >&3
      while read line; do
          [[ $mark -eq 1 ]] && echo $line
          if [[ "${line}" =~ "${tag}" ]]; then
              mark=1
          fi
      done <&3
      exec 3>&-
  }

  __wget "$1" > "$2"
  validate_download "$2" || return 1
  return 0
}

# other ideas:
# - use rsync
# - use openssl
# - use netcat
# - ksh tcp port
# - zsh tcp port http://web-tech.ga-usa.com/2014/04/zsh-simple-network-port-checker/
# on EL, download using RPM directly
# gnu gawk https://www.gnu.org/software/gawk/manual/gawkinet/html_node/TCP-Connecting.html http://www.linuxjournal.com/article/3132
# openssh "netcat mode" http://blog.rootshell.be/2010/03/08/openssh-new-feature-netcat-mode/
# openssl client?
# use rubygems directly
# fall back to trying to install curl/wget
