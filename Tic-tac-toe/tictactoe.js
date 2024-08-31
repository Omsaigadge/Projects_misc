let boxes=document.querySelectorAll(".box");
let reset=document.querySelector("#reset-btn");
let newbtn=document.querySelector('#new-btn');
let msgcontainer=document.querySelector('.hidden-container');
let msg=document.querySelector('#msg');

let count=0;
let turn=true;

const winconditions=[
                [0,1,2],
                [0,3,6],
                [0,4,8],
                [1,4,7],
                [2,5,8],
                [3,4,5],
                [6,7,8],
                [2,4,6]
            ];

boxes.forEach((box)=>{
    box.addEventListener("click",()=>{
        console.log("Box was clicked");
        if(turn)
        {
            box.innerText="O";
            turn=false;
        }
        else
        {
            box.innerText="X";
            turn=true;
        }

        box.disabled=true;
        count++;


        let isWinner=checkwinner();

        if(count===9 && !isWinner)
        {
            drawCondition();
        }
    });
});

const drawCondition = () =>
{
    msg.innerText =`It's a draw!`;
    msgcontainer.classList.remove('hide');
    disableboxes();
}

const enableboxes=()=>
{
    for(let box of boxes)
    {
        box.disabled=false;
        box.innerText="";
    }
}

const disableboxes=()=>
{
    for(let box of boxes)
    {
        box.disabled=true;
    }
}

const resetgame=()=>
{
    turn=true;
    count=0;
    enableboxes();
    msgcontainer.classList.add('hide');
}

const showWinner=(winner)=>
{
    msg.innerText= ` ${winner} won!`;
    msgcontainer.classList.remove('hide');
    disableboxes();
}



const checkwinner=()=>
{
    for (let pattern of winconditions) {
        let pos1Val = boxes[pattern[0]].innerText;
        let pos2Val = boxes[pattern[1]].innerText;
        let pos3Val = boxes[pattern[2]].innerText;
    
        if (pos1Val != "" && pos2Val != "" && pos3Val != "") {
          if (pos1Val === pos2Val && pos2Val === pos3Val) {
            console.log('winner is ',pos1Val);
            showWinner(pos1Val);
            return true;
          }
        }
    }
};



newbtn.addEventListener('click',resetgame);
reset.addEventListener('click',resetgame);
