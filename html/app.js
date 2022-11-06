var imeSkripte = "esxbalkan_mafije"

function zatvoriglavno() {
    $.post(`https://${GetParentResourceName()}/zatvori`, JSON.stringify({}));
    $(".container").fadeOut();
    $(".listaclanova").fadeOut();
    $('#employeelistaid').val("");
    $(".stavljanjepara").fadeOut();
    $(".vadjenjepara").fadeOut();
    $('#kolicinastavljanja').val("");
    $("#intro").val("");
    $("#tbl-content").empty();
    $(".zaposljavanje_div").fadeOut();
    $("#idigraca").val("");
    $(".employees_count .content-tabele .clanovilista").empty();
    $("#info-container").html('')
    $("#lista-container").html('')
    $("#final-container").html("")
    document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
}


window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.type == "open") {
        $(".container").fadeIn();
        document.getElementById("intro").innerHTML = item.organizacija + " - " + item.organizacijarank
        document.getElementById("cashKodNjeg").innerHTML = item.pareKes + "$  <br> NOVCA U VASEM DZEPU!"
        document.getElementById("pareOdFirme").innerHTML = item.pareFirma + "$  <br> NOVCA U SEFU FIRME!"
        document.getElementById("pareBankica").innerHTML = item.pareBanka + "$  <br> NOVCA U VASOJ BANCI!"
        document.getElementById("pareufirminastavljanju").innerHTML = "Pare u firmi: $" + item.pareFirma
        document.getElementById("pareufirminavadjenju").innerHTML = "Pare u firmi: $" + item.pareFirma
    }
    if (item.type == "listazaposlenih") {
        listazaposlenih(item)
        $("#info-container").fadeOut()
    }
});




function refres(){
    setTimeout(function(){
        $("igraci tbody").empty();
        $("#info-container").html('')
        $("#lista-container").html('')
        $("#final-container").html("")
        $.post(`https://${GetParentResourceName()}/refreshajlal`, JSON.stringify({}));
      }, 500)
}

function zaposlifrajera() {
    var identifier = $(".tabelamrtvaa").attr("identifier")
    $.post(`https://${GetParentResourceName()}/zaposlibtn`, JSON.stringify({
        identifier: identifier
    }));
    $(".igraci").empty();
    setTimeout(function(){
       $.post(`https://${GetParentResourceName()}/refreshajlal`, JSON.stringify({}));
      }, 500)
}





function OtvoriMenuZaStavljanjePara() {
    $(".stavljanjepara").fadeIn();
}

function OtvoriMenuZaVadjenjePara() {
    $(".vadjenjepara").fadeIn();
}

function zaposliclana() {
    $(".container").slideUp(400);
    $(".zaposljavanje_div").fadeIn();
    $('#idigraca').val("");
    $.post(`https://${GetParentResourceName()}/zaposlixd`, JSON.stringify({}));

}

function staviNovac(){
    var kolicinastavljanja = document.getElementById('kolicinastavljanja')
    data = [kolicinastavljanja];
    $.post(`https://${GetParentResourceName()}/stavinovac`, JSON.stringify({
        kolicinastavljanja: $("#kolicinastavljanja").val(),
    }));
      $(".stavljanjepara").fadeOut();
      $('#kolicinastavljanja').val("");
}

function izvadiNovac() {
    var kolicinavadjenja = document.getElementById('kolicinavadjenja')
    data = [kolicinavadjenja];
    $.post(`https://${GetParentResourceName()}/izvadinovac`, JSON.stringify({
        kolicinavadjenja: $("#kolicinavadjenja").val(),
    }));
      $(".vadjenjepara").fadeOut();
      $("#kolicinavadjenja").val("");
}


function otvorilistuclanova() {
    $(".container").slideUp(400);
    $(".listaclanova").fadeIn();
    $.post(`https://${GetParentResourceName()}/listaclanovaopn`, JSON.stringify({}));
}

function zaposliigraca () {
    var id = document.getElementById("idigraca").value;
    $('#idigraca').val("");
	$.post(`https://${GetParentResourceName()}/zaposliIgraca`, JSON.stringify({id: id}));
}

function zatvoristavljanje() {
    $(".stavljanjepara").fadeOut();
}

function zatvorivadjenje() {
    $(".vadjenjepara").fadeOut();
}

function zatvorizaposljavanje() {
    $(".zaposljavanje_div").fadeOut();
    $(".container").fadeIn();
    $('#idigraca').val("");
}

function setupPage(data) {
    if (data.rod == "m") {
        rod = "Musko"
    } else {
        rod = "Zensko"
    }
    $("#info-container").append(`
    <div id="identifier" style="display: none;">` + data.identifier + `</div>
    <div id="informacijeigraca">INFORMACIJE IGRACA </div>
    <div id="imeigraca">Ime igraca: ` + data.firstname +` </div>
    <div id="brojtelefona">Broj Telefona: ` + data.brojtelefona + ` </div>
    <div id="cinOrg">Rank: ` + data.rank_label + " " + data.grade_number + ` </div>
    <div id="rodOrg">Rod: ` + rod + ` </div>
    <button class="otkazBtn" id="otkazBtn" ><i class="fa fa-times"></i> | Otkaz</button>
    <button class="promovirajBtn" id="promovirajBtn" ><i class="fa fa-arrow-up"></i> | Promoviraj</button>
    <button class="degradirajBtn" id="degradirajBtn" ><i class="fa fa-arrow-down"></i> | Degradiraj</button>
    `);

    // OTKAZ //
    $("#otkazBtn").click(function() {
        var identifier = data.identifier
        $.post(`https://${GetParentResourceName()}/otkaz`, JSON.stringify({
            identifier: identifier
        }));
        setTimeout(function(){
            zatvorilistuzaposlenih()
            document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
           }, 500)
    });
    
        // PROMOVIRAJ //
        $("#promovirajBtn").click(function() {
            var identifier = data.identifier
            var nowGrade = data.grade_number
            $.post(`https://${GetParentResourceName()}/unaprijediClana`, JSON.stringify({
                identifier: identifier,
                nowGrade: nowGrade
            }));
            setTimeout(function(){
                zatvorilistuzaposlenih()
                document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
            }, 500)
        });

        // Degradiraj //
        $("#degradirajBtn").click(function() {
            var identifier = data.identifier
            var nowGrade = data.grade_number
            $.post(`https://${GetParentResourceName()}/degradirajClana`, JSON.stringify({
                identifier: identifier,
                nowGrade: nowGrade
            }));

            setTimeout(function(){
                zatvorilistuzaposlenih()
                document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
            }, 500)
        });
}

function listazaposlenih(item) {
    document.getElementById("brojclanova").innerHTML = "Broj clanova: " + item.employeescount
    $("#lista-container").append(`
    <div class="row">
          <div style="cursor: pointer; user-select: none; user-zoom: none;" class="col-12 lista-karta my-2"<i id="btn-`+ item.identifier +`"></i>
              <div class="col-2 d-flex align-items-center"><span class="">` + item.firstname +`</span></div>
              </div>
          </div>
      </div>
  `);

  $("#btn-" + item.identifier).click(function() {
    $("#info-container").html('')
    $("#final-container").html("")
    $("#info-container").fadeIn()
    setupPage(item)
});

}



function degradirajga() {
    var identifier = $(".tabelamrtvaa").attr("personID");
    var grade = $(".tabelamrtvaa").attr("grade");
    console.log(identifier)
    $.post(`https://${GetParentResourceName()}/degradirajClana`, JSON.stringify({
        identifier: identifier,
        grade: grade,
    }));
    setTimeout(function(){
        zatvorilistuzaposlenih()
    }, 500)
}

function otkaz() {
    var identifier = $(".tabelamrtvaa").attr("personID");
    var grade = $(".tabelamrtvaa").attr("grade");
    $.post(`https://${GetParentResourceName()}/otkaz`, JSON.stringify({
        identifier: identifier,
        grade: grade,
    }));
    setTimeout(function(){
        zatvorilistuzaposlenih()
        document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
       }, 500)
}

function unaprijedi() {
    var identifier = $(".tabelamrtvaa").attr("personID");
    var grade = $(".tabelamrtvaa").attr("grade");
    document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
    $.post(`https://${GetParentResourceName()}/unaprijediClana`, JSON.stringify({
        identifier: identifier,
        grade: grade,
    }));
    setTimeout(function(){
        zatvorilistuzaposlenih()
    }, 500)
}

function zatvoriMeni() {
    $.post(`https://${GetParentResourceName()}/zatvori`, JSON.stringify({}));
    zatvoriglavno()
}

function zatvorilistuzaposlenih() {
    $(".listaclanova").fadeOut();
    $(".container").fadeIn();
    $("#info-container").html('')
    $("#lista-container").html('')
    $("#final-container").html("")
    document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
}

$(document).keyup(function (e) {
    if (e.keyCode == 27) {
        $(".container").fadeOut();
        $(".listaclanova").fadeOut();
        $('#employeelistaid').empty();
        $(".stavljanjepara").fadeOut();
        $(".vadjenjepara").fadeOut();
        $('#kolicinastavljanja').empty();
        $("#intro").empty();
        $("#tbl-content").empty();
        $(".zaposljavanje_div").fadeOut();
        $(".idigraca").val("");
        $(".employees_count .content-tabele .clanovilista").empty();
        $("#info-container").html('')
        $("#lista-container").html('')
        $("#final-container").html("")
        document.getElementById("brojclanova").innerHTML = "Broj clanova: 0"
        $.post(`https://${GetParentResourceName()}/zatvori`, JSON.stringify({}));
    }
});



