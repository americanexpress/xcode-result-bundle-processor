document.addEventListener('click', function(e) {
    if (!e.target.matches('a.viewSnapshot')) {
        return;
    }

    var snapshot = e.target.parentElement.querySelector('pre.snapshot');

    var w = window.open('about:blank', 'snapshot',
        'dependent=1,width=800,height=500,left=' + (e.screenX - 80) + ',top=' + (e.screenY - 80));
    w.document.body.appendChild(snapshot);

    e.preventDefault();
    return false;
});