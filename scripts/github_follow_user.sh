#!/bin/bash

fetch_following(){
  local TOKEN=${1}
  local USERNAME=${2}

  echo `
    curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN"\
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/users/$GITHUB_USERNAME/following?per_page=100
  `
}


fetch_followers(){
  curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/followers?per_page=100
}

unfollow(){
  local USERNAME=${1}

  curl -L \
    -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/following/$USERNAME
}

diff_following_from_followers(){
  local following=`fetch_following |jq ".[].login" -S| sed 's/"//g'`
  local followers=`fetch_followers |jq ".[].login" -S| sed 's/"//g'`

  local tmp1="xxxxxxxxxxxxx_following.txt"
  local tmp2="xxxxxxxxxxxxx_followers.txt"
  echo "$following" > $tmp1
  echo "$followers" > $tmp2

  local diff=`sort $tmp1 $tmp2 $tmp2| uniq -u`
  for one in $diff;do
    unfollow $one
    echo "deleted $one"
  done

  rm $tmp1 $tmp2
}

diff_following_from_followers
