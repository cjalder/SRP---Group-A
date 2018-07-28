
var test = new iframe();
test.id  = 'asdf'
test.iframe.height = '625';
test.iframe.width  = 'auto';
test.iframe.border = "2px solid black";
test.iframe.src = 'http://bioinf6.bioc.le.ac.uk:3838/srpgrpa/Volcano_rn4/';


function iframe()
{
    this.iframe = document.createElement('IFRAME');
    this.id     = null;
    this.preload= function()
    {
        if (this.id) {
            document.getElementById(this.id).appendChild(this.iframe);
        }
    }
    this.show = function() {document.getElementById(this.id).style.display = 'block'; }
    this.hide = function() {document.getElementById(this.id).style.display = 'none'; }
}

