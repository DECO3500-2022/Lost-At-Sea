function ajax_get_page(method, path, element) {
    let request = new XMLHttpRequest();
    request.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            document.getElementById(element).innerHTML = this.responseText;
        }
    };
    request.open(method, path, true);
    request.send();
}