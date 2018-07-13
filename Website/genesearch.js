/*THIS IS NOT WORKING*/
/*https://www.w3schools.com/howto/tryit.asp?filename=tryhow_js_search_menu*/
/*^is what the code should look like and do*/
function genesearch() {
    var input, filter, ul, li, a, i;
    input = document.getElementById("genesearch");
    filter = input.value.toUpperCase();
    ul = document.get_ElementsById("geneID");
    li = ul.getElementsByTagName("li");
    for i = 0; < li.length; i ++) {
        a = li[i].getElementsByTagName("li")[0];
        if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
            li[i].style.display = "";
        } else {
            li[i].style.display = "none";
        }
    }
}

