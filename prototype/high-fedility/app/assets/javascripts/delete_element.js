function delete_emement_by_id(element_id) {
    var element=document.getElementById(element_id);
    element.parentNode.removeChild(element);
}
