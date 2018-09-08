#!/bin/sh
ESCAPE_CHAR=$'\033'
menuStr=""

# 清屏操作
function clearLastMenu(){
  local msgLineCount=$(printf "$menuStr" | wc -l)
  echo -en "$ESCAPE_CHAR[${msgLineCount}A"
  printf "${ESCAPE_CHAR}c"
}

# 用于打印列表
function renderMenu(){
  local instruction="$1"
  local selectedIndex=$2
  local selector=""

  menuStr="\n $instruction\n"

  for (( i=0; i<$listLength; i++ )); do
    local currItem="${menuItems[i]}"
    
    if [[ $i = $selectedIndex ]]; then 
      selector=">"
      selectedItem="$currItem"
    else
      selector=" "
    fi

    menuStr="$menuStr\n $selector ${currItem}"
  done

  clearLastMenu
  printf "$menuStr\n"
}

function selectionMenu(){
  # 按键设置
  local KEY_ARROW_UP=$(echo -e "$ESCAPE_CHAR[A")
  local KEY_ARROW_DOWN=$(echo -e "$ESCAPE_CHAR[B")
  local KEY_ENTER=$(echo -e "\n")
  # 读取参数
  local instruction=$1
  local menuItems=$2[@]
        menuItems=("${!menuItems}")
  local listLength=${#menuItems[@]}
  local selectedIndex=${3:-0}
  local flagLoop=${4:-false}
  # 等待选择
  local flagWaitingEnter=true

  # 没有提供列表项
  if [[ $listLength -lt 1 ]]; then
    printf "错误: 未提供列表\n"
    return 1
  fi

  renderMenu "$instruction" $selectedIndex

  while $flagWaitingEnter; do
    
    read -rsn3 inpKey # `3` 代表 escape (\033'), bracket ([) 和 ASCII 控制字符

    case "$inpKey" in
      "$KEY_ARROW_UP")
        selectedIndex=$((selectedIndex-1))
        (( $selectedIndex < 0 )) && selectedIndex=0 && $flagLoop && selectedIndex=$((listLength-1))
        ;;

      "$KEY_ARROW_DOWN")
        selectedIndex=$((selectedIndex+1))
        (( $selectedIndex == $listLength )) && selectedIndex=$((listLength-1)) && $flagLoop && selectedIndex=0 
        ;;
        
      "$KEY_ENTER")
        clearLastMenu
        flagWaitingEnter=false
        echo $selectedItem
        return 0
        ;;
    esac
    
    renderMenu "$instruction" $selectedIndex
  done
}
