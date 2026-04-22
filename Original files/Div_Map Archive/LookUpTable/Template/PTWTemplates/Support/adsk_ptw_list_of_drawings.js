/* 
	Copyright 1988-2000 by Autodesk, Inc.

	Permission to use, copy, modify, and distribute this software
	for any purpose and without fee is hereby granted, provided
	that the above copyright notice appears in all copies and
	that both that copyright notice and the limited warranty and
	restricted rights notice below appear in all supporting
	documentation.

	AUTODESK PROVIDES THIS PROGRAM "AS IS" AND WITH ALL FAULTS.
	AUTODESK SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF
	MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE.  AUTODESK, INC.
	DOES NOT WARRANT THAT THE OPERATION OF THE PROGRAM WILL BE
	UNINTERRUPTED OR ERROR FREE.

	Use, duplication, or disclosure by the U.S. Government is subject to
	restrictions set forth in FAR 52.227-19 (Commercial Computer
	Software - Restricted Rights) and DFAR 252.227-7013(c)(1)(ii) 
	(Rights in Technical Data and Computer Software), as applicable.

    Autodesk Publish to Web JavaScript 
    
    Template element id: adsk_ptw_list_of_drawings
    Publishing content:  label

    Template element id: adsk_ptw_image_description
    Publishing content:  description

    Template element id: adsk_ptw_image
    Publishing content:  image

    Template element id: adsk_ptw_idrop
    Publishing content:  idrop

    Template element id: adsk_ptw_summary_frame
    Publishing content:  drawing summary    
*/

adsk_ptw_list_of_drawings_main();

function adsk_ptw_list_of_drawings_main() {
    var xmle=adsk_ptw_xml.getElementsByTagName("publish_to_web").item(0);
    xmle=xmle.getElementsByTagName("contents").item(0);
    var xmles=xmle.getElementsByTagName("content");
    var e = document.getElementById("adsk_ptw_list_of_drawings");

    table = document.createElement("table");
    tbody = document.createElement("tbody");
    e.appendChild(table);
    table.appendChild(tbody);
    tr = document.createElement("tr");
    tbody.appendChild(tr);
    tr.align="left";
    tr.vAlign="top"

    td = document.createElement("td"); 
    tr.appendChild(td);
    table2=document.createElement("table"); 
    td.appendChild(table2);
    table2.cellPadding=1;
    table2.cellSpacing=5;

    tbody2=document.createElement("tbody");
    table2.appendChild(tbody2);
    td2 = document.createElement("td"); 
    tr.appendChild(td2);
    for (i=0; i < xmles.length; i++) {
        content=xmles.item(i);      
        title = content.getElementsByTagName("title").item(0);
        a=document.createElement("a"); 
        if (null == title.firstChild) {
            a.appendChild(document.createTextNode(" "));
        }
        else {
            a.appendChild(document.createTextNode(title.firstChild.text));
        }
        table2_tr=document.createElement("tr");
        tbody2.appendChild(table2_tr);
        table2_td=document.createElement("td");
        table2_tr.appendChild(table2_td);
        table2_td.appendChild(a);
        a.className="DRAWING_LABEL";
        var fileName = content.getElementsByTagName("image").item(0).firstChild.text;
        a.id=fileName;
        a.value=i;   
        if (adsk_ptw_list_of_drawings_is_image_dwf(fileName)) {  
            a.href="javascript:adsk_ptw_list_of_drawings_onClickViewer()";
        } else {
            a.href="javascript:adsk_ptw_list_of_drawings_onClickImage()";
        }
    }
}

function adsk_ptw_list_of_drawings_createViewerControl (i) {
    dwg_img_desc=parent.adsk_ptw_image_frame.document.getElementById("adsk_ptw_image_description");
	dwg_img_desc.removeChild(dwg_img_desc.firstChild);

    var xmle=adsk_ptw_xml.getElementsByTagName("publish_to_web").item(0);
    xmle=xmle.getElementsByTagName("contents").item(0);
    xmles=xmle.getElementsByTagName("content");
    desc = xmles.item(i).getElementsByTagName("description").item(0);
    p = parent.adsk_ptw_image_frame.document.createElement("p");
    if (null == desc.firstChild) {
        p.appendChild(parent.adsk_ptw_image_frame.document.createTextNode(""));
    }
    else {
        p.appendChild(parent.adsk_ptw_image_frame.document.createTextNode(desc.firstChild.text));
    }
    dwg_img_desc.appendChild(p);

    dwg_img=parent.adsk_ptw_image_frame.document.getElementById("adsk_ptw_image");
	dwg_img.removeChild(dwg_img.firstChild); 
    activex = parent.adsk_ptw_image_frame.document.createElement("object");
    dwg_img.appendChild(activex);
    activex.classid="clsid:A662DA7E-CCB7-4743-B71A-D817F6D575DF";

    var URL=document.location.href;
    var fileName=xmles.item(i).getElementsByTagName("image").item(0).firstChild.text;
    activex.id="AdView";
    var temp_url = URL;    
    temp_url = temp_url.replace("file:///", "file://");
    activex.SourcePath=(temp_url.substring(0, temp_url.lastIndexOf('/') + 1)) + fileName;
    activex.Viewer.ToolbarVisible=false;
    activex.border="1";
    activex.width="500";
    activex.height="360";

    viewerInstalled = false;
	IE4plus = (document.all) ? true : false;
	if (IE4plus)
	    // try and catch work fine in IE, but will generate errors in Netscape. So evaluating try and catch block as string and evaluate it usung eval fuction
  	    eval ('try {var xObj = new ActiveXObject("AdView.Adviewer");if (xObj == null) viewerInstalled = false; else viewerInstalled = true; } catch (e) { viewerInstalled = false; }');

	if (!viewerInstalled)
		adsk_ptw_onerror(); // Redirects the user to a website where they can download Autodest Express Viewer

    adsk_ptw_list_of_drawings_setiDrop(i);
}

function adsk_ptw_list_of_drawings_onClickViewer() { 
    adsk_ptw_list_of_drawings_createViewerControl (document.activeElement.value);
    adsk_ptw_list_of_drawings_set_summary_info(document.activeElement.value);
}

function adsk_ptw_list_of_drawings_createImageElement(i) {
    dwg_img_desc=parent.adsk_ptw_image_frame.document.getElementById("adsk_ptw_image_description");
	dwg_img_desc.removeChild(dwg_img_desc.firstChild);

    var xmle=adsk_ptw_xml.getElementsByTagName("publish_to_web").item(0);
    xmle=xmle.getElementsByTagName("contents").item(0);
    var xmles=xmle.getElementsByTagName("content");
    desc = xmles.item(i).getElementsByTagName("description").item(0);
    p = parent.adsk_ptw_image_frame.document.createElement("p");
    if (null == desc.firstChild) {
        p.appendChild(parent.adsk_ptw_image_frame.document.createTextNode(""));
    }
    else {
        p.appendChild(parent.adsk_ptw_image_frame.document.createTextNode(desc.firstChild.text));
    }
    dwg_img_desc.appendChild(p);

    dwg_img=parent.adsk_ptw_image_frame.document.getElementById("adsk_ptw_image");
	dwg_img.removeChild(dwg_img.firstChild); 
    image = parent.adsk_ptw_image_frame.document.createElement("img");
    dwg_img.appendChild(image);
    image.src=xmles.item(i).getElementsByTagName("image").item(0).firstChild.text;
    image.border=1;

    adsk_ptw_list_of_drawings_setiDrop(i);
}

function adsk_ptw_list_of_drawings_onClickImage() {
    adsk_ptw_list_of_drawings_createImageElement(document.activeElement.value);
    adsk_ptw_list_of_drawings_set_summary_info(document.activeElement.value);
}

function adsk_ptw_list_of_drawings_setiDrop(i) {
    dwg_idrop = parent.adsk_ptw_image_frame.document.getElementById("adsk_ptw_idrop");
    if (null != dwg_idrop.firstChild) {
	    dwg_idrop.removeChild(dwg_idrop.firstChild); 
    }
    var xmle=adsk_ptw_xml.getElementsByTagName("publish_to_web").item(0);
    xmle=xmle.getElementsByTagName("contents").item(0);
    var xmles=xmle.getElementsByTagName("content");
    idrop = xmles.item(i).getElementsByTagName("iDropXML").item(0);
    if (null != idrop.firstChild) {
        activex = parent.adsk_ptw_image_frame.document.createElement("object");
        dwg_idrop.appendChild(activex);
        activex.codeBase=xmsg_adsk_ptw_all_idrop_url;
        activex.classid="clsid:21E0CB95-1198-4945-A3D2-4BF804295F78";
        activex.package=idrop.firstChild.text;
        activex.background="iDropButton.gif";
        activex.width="16";
        activex.height="16";
    }
}

function adsk_ptw_list_of_drawings_set_summary_info(i) {
    if (null == parent) return;
    if (null == parent.adsk_ptw_summary_frame) return;

    body=parent.adsk_ptw_summary_frame.document.getElementsByTagName("body").item(0);
    n=body.childNodes.length;
    for (index=0; index < n; index++) {
        body.removeChild(body.firstChild);
    }

    var xmle=adsk_ptw_xml.getElementsByTagName("publish_to_web").item(0);
    xmle=xmle.getElementsByTagName("contents").item(0);
    var xmles=xmle.getElementsByTagName("content");
    sum_info = xmles.item(i).getElementsByTagName("summary_info").item(0);

    if (null != sum_info) {
        body=parent.adsk_ptw_summary_frame.document.getElementsByTagName("body").item(0);

        title=sum_info.getElementsByTagName("title").item(0);
        adsk_ptw_list_of_drawings_summary(body, xmsg_adsk_ptw_all_summaryTitle, title);

        subject=sum_info.getElementsByTagName("subject").item(0);
        adsk_ptw_list_of_drawings_summary(body, xmsg_adsk_ptw_all_summarySubject, subject);

        author=sum_info.getElementsByTagName("author").item(0);
        adsk_ptw_list_of_drawings_summary(body, xmsg_adsk_ptw_all_summaryAuthor, author);

        keywords=sum_info.getElementsByTagName("keywords").item(0);
        adsk_ptw_list_of_drawings_summary(body, xmsg_adsk_ptw_all_summaryKeywords, keywords);

        comments=sum_info.getElementsByTagName("comments").item(0);
        adsk_ptw_list_of_drawings_summary(body, xmsg_adsk_ptw_all_summaryComments, comments);
        
        hyperlink_base=sum_info.getElementsByTagName("hyperlink_base").item(0);
        adsk_ptw_list_of_drawings_summary(body, xmsg_adsk_ptw_all_summaryHyperlinkBase, hyperlink_base);
    }
}

function adsk_ptw_list_of_drawings_summary(rootNode, nameString, valueNode) {
    if (null == valueNode) return;
    if (null == valueNode.firstChild) return;

    b=parent.adsk_ptw_summary_frame.document.createElement("b");
    div=parent.adsk_ptw_summary_frame.document.createElement("div");
    rootNode.appendChild(div);
    div.appendChild(b);
    str = nameString + valueNode.firstChild.text;
    b.appendChild(parent.adsk_ptw_summary_frame.document.createTextNode(str));
}

function adsk_ptw_list_of_drawings_is_image_dwf(file_name) {
    var ext = file_name.substring(file_name.lastIndexOf('.') + 1, (file_name.length));
    return("dwf" == ext);
}

// SIG // Begin signature block
// SIG // MIIUkAYJKoZIhvcNAQcCoIIUgTCCFH0CAQExDjAMBggq
// SIG // hkiG9w0CBQUAMGYGCisGAQQBgjcCAQSgWDBWMDIGCisG
// SIG // AQQBgjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIB
// SIG // AAIBAAIBAAIBAAIBADAgMAwGCCqGSIb3DQIFBQAEEFY7
// SIG // bVdBzmJPOqeQrMqXQD6ggg+PMIICvDCCAiUCEEoZ0jiM
// SIG // glkcpV1zXxVd3KMwDQYJKoZIhvcNAQEEBQAwgZ4xHzAd
// SIG // BgNVBAoTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxFzAV
// SIG // BgNVBAsTDlZlcmlTaWduLCBJbmMuMSwwKgYDVQQLEyNW
// SIG // ZXJpU2lnbiBUaW1lIFN0YW1waW5nIFNlcnZpY2UgUm9v
// SIG // dDE0MDIGA1UECxMrTk8gTElBQklMSVRZIEFDQ0VQVEVE
// SIG // LCAoYyk5NyBWZXJpU2lnbiwgSW5jLjAeFw05NzA1MTIw
// SIG // MDAwMDBaFw0wNDAxMDcyMzU5NTlaMIGeMR8wHQYDVQQK
// SIG // ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMRcwFQYDVQQL
// SIG // Ew5WZXJpU2lnbiwgSW5jLjEsMCoGA1UECxMjVmVyaVNp
// SIG // Z24gVGltZSBTdGFtcGluZyBTZXJ2aWNlIFJvb3QxNDAy
// SIG // BgNVBAsTK05PIExJQUJJTElUWSBBQ0NFUFRFRCwgKGMp
// SIG // OTcgVmVyaVNpZ24sIEluYy4wgZ8wDQYJKoZIhvcNAQEB
// SIG // BQADgY0AMIGJAoGBANMuIPBofCwtLoEcsQaypwu3EQ1X
// SIG // 2lPYdePJMyqy1PYJWzTz6ZD+CQzQ2xtauc3n9oixncCH
// SIG // Jet9WBBzanjLcRX9xlj2KatYXpYE/S1iEViBHMpxlNUi
// SIG // WC/VzBQFhDa6lKq0TUrp7jsirVaZfiGcbIbASkeXarSm
// SIG // NtX8CS3TtDmbAgMBAAEwDQYJKoZIhvcNAQEEBQADgYEA
// SIG // YVUOPnvHkhJ+ERCOIszUsxMrW+hE5At4nqR+86cHch7i
// SIG // We/MhOOJlEzbTmHvs6T7Rj1QNAufcFb2jip/F87lY795
// SIG // aQdzLrCVKIr17aqp0l3NCsoQCY/Os68olsR5KYSS3P+6
// SIG // Z0JIppAQ5L9h+JxT5ZPRcz/4/Z1PhKxV0f0RY2MwggOq
// SIG // MIIDE6ADAgECAhBKKT6dHYxAfxdJ/31hX451MA0GCSqG
// SIG // SIb3DQEBBQUAMF8xCzAJBgNVBAYTAlVTMRcwFQYDVQQK
// SIG // Ew5WZXJpU2lnbiwgSW5jLjE3MDUGA1UECxMuQ2xhc3Mg
// SIG // MyBQdWJsaWMgUHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1
// SIG // dGhvcml0eTAeFw0wMTEyMTIwMDAwMDBaFw0wNDAxMDYy
// SIG // MzU5NTlaMIGpMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5j
// SIG // LjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29y
// SIG // azE7MDkGA1UECxMyVGVybXMgb2YgdXNlIGF0IGh0dHBz
// SIG // Oi8vd3d3LnZlcmlzaWduLmNvbS9ycGEgKGMpMDExMDAu
// SIG // BgNVBAMTJ1ZlcmlTaWduIENsYXNzIDMgQ29kZSBTaWdu
// SIG // aW5nIDIwMDEtNCBDQTCBnzANBgkqhkiG9w0BAQEFAAOB
// SIG // jQAwgYkCgYEAnoG1Ys2H82OZbSnKmKsRtbVGNLUilYKo
// SIG // e1b9Xg0YGyhjKUJJAxmGin3lUFFJ+pHaz7MOy3PEOOBA
// SIG // 5Go0sNzr6+DMw8qR2Nr7QNKF09rf4l8ulxnbntEI0H2F
// SIG // wCDOzIxxpuVNWj4ZlzD/yM76m0Y3vNL2zClfJ3OToaA4
// SIG // 3hScu6MCAwEAAaOCARowggEWMBIGA1UdEwEB/wQIMAYB
// SIG // Af8CAQAwRAYDVR0gBD0wOzA5BgtghkgBhvhFAQcXAzAq
// SIG // MCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy52ZXJpc2ln
// SIG // bi5jb20vcnBhMDMGA1UdHwQsMCowKKImhiRodHRwOi8v
// SIG // Y3JsLnZlcmlzaWduLmNvbS9wY2EzLjEuMS5jcmwwHQYD
// SIG // VR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMA4GA1Ud
// SIG // DwEB/wQEAwIBBjARBglghkgBhvhCAQEEBAMCAAEwJAYD
// SIG // VR0RBB0wG6QZMBcxFTATBgNVBAMTDENsYXNzM0NBMS0x
// SIG // MzAdBgNVHQ4EFgQUT+u6lxTKm1OV7rF6TlSXDbUEoRww
// SIG // DQYJKoZIhvcNAQEFBQADgYEAWumXyXj/yYyx+PzeX9zk
// SIG // pD0cuf/TIcrXABFuJtFnKyZyWgbE1sPwWQQewgiuRpxG
// SIG // TtHSAW6amXe/1R3uHNwpqr3eBVHH8o0ZtdkK7Bum62q6
// SIG // SRhDU16W/MtpqAWNPgqLDkC8x1STQPy2a1cPoS/0ebVq
// SIG // J5C+e/yOp3xlSmQvHAEwggQCMIIDa6ADAgECAhAIem1c
// SIG // b2KTT7rE/UPhFBidMA0GCSqGSIb3DQEBBAUAMIGeMR8w
// SIG // HQYDVQQKExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMRcw
// SIG // FQYDVQQLEw5WZXJpU2lnbiwgSW5jLjEsMCoGA1UECxMj
// SIG // VmVyaVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNlIFJv
// SIG // b3QxNDAyBgNVBAsTK05PIExJQUJJTElUWSBBQ0NFUFRF
// SIG // RCwgKGMpOTcgVmVyaVNpZ24sIEluYy4wHhcNMDEwMjI4
// SIG // MDAwMDAwWhcNMDQwMTA2MjM1OTU5WjCBoDEXMBUGA1UE
// SIG // ChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlT
// SIG // aWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1z
// SIG // IG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJpc2lnbi5j
// SIG // b20vcnBhIChjKTAxMScwJQYDVQQDEx5WZXJpU2lnbiBU
// SIG // aW1lIFN0YW1waW5nIFNlcnZpY2UwggEiMA0GCSqGSIb3
// SIG // DQEBAQUAA4IBDwAwggEKAoIBAQDAemGH67KnA2MbKxph
// SIG // 3oC3FR2gi5A9uyeShBQ564XOKZIGZkikA0+N6E+n8K9e
// SIG // 0S8Zx5HxtZ57kSHO6f/jTvD8r5VYuGMt5o72KRjNcI5Q
// SIG // w+2Wu0DbviXoQlXW9oXyBueLmRwx8wMP1EycJCrcGxuP
// SIG // gvOw76dN4xSn4I/Wx2jCYVipctT4MEhP2S9vYyDZicqC
// SIG // e8JLvCjFgWjn5oJArEY6oPk/Ns1Mu1RCWnple/6E5MdH
// SIG // VKy5PeyAxxr3xDOBgckqlft/XjqHkBTbzC518u9r5j2p
// SIG // YL5CAapPqluoPyIxnxIV+XOhHoKLBCvqRgJMbY8fUC6V
// SIG // Syp4BoR0PZGPLEcxAgMBAAGjgbgwgbUwQAYIKwYBBQUH
// SIG // AQEENDAyMDAGCCsGAQUFBzABhiRodHRwOi8vb2NzcC52
// SIG // ZXJpc2lnbi5jb20vb2NzcC9zdGF0dXMwCQYDVR0TBAIw
// SIG // ADBEBgNVHSAEPTA7MDkGC2CGSAGG+EUBBwEBMCowKAYI
// SIG // KwYBBQUHAgEWHGh0dHBzOi8vd3d3LnZlcmlzaWduLmNv
// SIG // bS9ycGEwEwYDVR0lBAwwCgYIKwYBBQUHAwgwCwYDVR0P
// SIG // BAQDAgbAMA0GCSqGSIb3DQEBBAUAA4GBAC3zT2NgLBja
// SIG // 9SQPUrMM67O8Z4XCI+2PRg3PGk2+83x6IDAyGGiLkrsy
// SIG // mfCTuDsVBid7PgIGAKQhkoQTCsWY5UBXxQUl6K+vEWqp
// SIG // 5TvL6SP2lCldQFXzpVOdyDY6OWUIc3OkMtKvrL/HBTz/
// SIG // RezD6Nok0c5jrgmn++Ib4/1BCmqWMIIFFzCCBICgAwIB
// SIG // AgIQIQ/ItWeoaJ+iNv1eJpFWIjANBgkqhkiG9w0BAQQF
// SIG // ADCBqTEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAd
// SIG // BgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOzA5
// SIG // BgNVBAsTMlRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3
// SIG // dy52ZXJpc2lnbi5jb20vcnBhIChjKTAxMTAwLgYDVQQD
// SIG // EydWZXJpU2lnbiBDbGFzcyAzIENvZGUgU2lnbmluZyAy
// SIG // MDAxLTQgQ0EwHhcNMDIwOTA5MDAwMDAwWhcNMDMwOTIy
// SIG // MjM1OTU5WjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgT
// SIG // CkNhbGlmb3JuaWExEzARBgNVBAcTClNhbiBSYWZhZWwx
// SIG // FjAUBgNVBAoUDUF1dG9kZXNrLCBJbmMxPjA8BgNVBAsT
// SIG // NURpZ2l0YWwgSUQgQ2xhc3MgMyAtIE1pY3Jvc29mdCBT
// SIG // b2Z0d2FyZSBWYWxpZGF0aW9uIHYyMSIwIAYDVQQLFBlE
// SIG // ZXNpZ24gU29sdXRpb25zIERpdmlzaW9uMRYwFAYDVQQD
// SIG // FA1BdXRvZGVzaywgSW5jMIGfMA0GCSqGSIb3DQEBAQUA
// SIG // A4GNADCBiQKBgQDn89FlMMksQAE/S7d+0QDhHbq6ZLxl
// SIG // ptXbBUs9y6kgKaY2WiG7cKNAd1oekhX4drb/CLwYSBJ5
// SIG // wexMmEsD4b1Nqt5PGyK1GpwyVV28k5UXNDVzTemnlnxL
// SIG // hn6y+iALPLFx1Lh+pbGt/OG3DXyOFGpXdthmVFminB3A
// SIG // WqKuIoSIlQIDAQABo4ICGjCCAhYwCQYDVR0TBAIwADAO
// SIG // BgNVHQ8BAf8EBAMCB4AwRAYDVR0fBD0wOzA5oDegNYYz
// SIG // aHR0cDovL2NybC52ZXJpc2lnbi5jb20vQ2xhc3MzQ29k
// SIG // ZVNpZ25pbmdDQTIwMDEuY3JsMIGgBgNVHSAEgZgwgZUw
// SIG // gZIGC2CGSAGG+EUBBwEBMIGCMDMGCCsGAQUFBwIBFido
// SIG // dHRwczovL3d3dy52ZXJpc2lnbi5jb20vcmVwb3NpdG9y
// SIG // eS9DUFMwSwYIKwYBBQUHAgIwPxo9VmVyaVNpZ24ncyBD
// SIG // UFMgaW5jb3JwLiBieSByZWZlcmVuY2UgbGlhYi4gbHRk
// SIG // LiAoYyk5OSBWZXJpU2lnbjATBgNVHSUEDDAKBggrBgEF
// SIG // BQcDAzA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGG
// SIG // GWh0dHBzOi8vb2NzcC52ZXJpc2lnbi5jb20wgZgGA1Ud
// SIG // IwSBkDCBjYAUT+u6lxTKm1OV7rF6TlSXDbUEoRyhY6Rh
// SIG // MF8xCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5WZXJpU2ln
// SIG // biwgSW5jLjE3MDUGA1UECxMuQ2xhc3MgMyBQdWJsaWMg
// SIG // UHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eYIQ
// SIG // Sik+nR2MQH8XSf99YV+OdTARBglghkgBhvhCAQEEBAMC
// SIG // BBAwFgYKKwYBBAGCNwIBGwQIMAYBAQABAf8wDQYJKoZI
// SIG // hvcNAQEEBQADgYEAR/N0E/CyozBkCNlYnH+I3qmVveNR
// SIG // 9gJ8dSmHiXpLPn1l68xDVsQjvL5OEQy0cDBLLuZ2+Ucm
// SIG // yi65WBeTJVqeUJsb2pTJDZEyGqD0vEaYWPAJ71+BO36i
// SIG // MOjM4h/ZQCIR6iKUozbRpnc1n3G+AA0G0QKWnricAnNp
// SIG // mt5ak07ew3IxggRrMIIEZwIBATCBvjCBqTEXMBUGA1UE
// SIG // ChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlT
// SIG // aWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1z
// SIG // IG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJpc2lnbi5j
// SIG // b20vcnBhIChjKTAxMTAwLgYDVQQDEydWZXJpU2lnbiBD
// SIG // bGFzcyAzIENvZGUgU2lnbmluZyAyMDAxLTQgQ0ECECEP
// SIG // yLVnqGifojb9XiaRViIwDAYIKoZIhvcNAgUFAKCBsDAZ
// SIG // BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
// SIG // AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAfBgkqhkiG9w0B
// SIG // CQQxEgQQOvnPD2PzjIryirV2xDEQVDBUBgorBgEEAYI3
// SIG // AgEMMUYwRKAmgCQAQQB1AHQAbwBkAGUAcwBrACAAQwBv
// SIG // AG0AcABvAG4AZQBuAHShGoAYaHR0cDovL3d3dy5hdXRv
// SIG // ZGVzay5jb20gMA0GCSqGSIb3DQEBAQUABIGAzNxYHK8h
// SIG // s+dZCZnfdvT6iiPnHT7fmHa++j91zmQsm7dQkZVSEepb
// SIG // lJ9c6+4AkHy/SfhmZc7oAf9lhsl1BCRbEE/lXjtODXIj
// SIG // mScWNBzvz+WjIu/DxF9AKZjBPW/7IfPLsSXKjFoD6lrH
// SIG // SCARB0iCm7kCr+Me9Z1NQDmt7YvEcrChggJMMIICSAYJ
// SIG // KoZIhvcNAQkGMYICOTCCAjUCAQEwgbMwgZ4xHzAdBgNV
// SIG // BAoTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxFzAVBgNV
// SIG // BAsTDlZlcmlTaWduLCBJbmMuMSwwKgYDVQQLEyNWZXJp
// SIG // U2lnbiBUaW1lIFN0YW1waW5nIFNlcnZpY2UgUm9vdDE0
// SIG // MDIGA1UECxMrTk8gTElBQklMSVRZIEFDQ0VQVEVELCAo
// SIG // Yyk5NyBWZXJpU2lnbiwgSW5jLgIQCHptXG9ik0+6xP1D
// SIG // 4RQYnTAMBggqhkiG9w0CBQUAoFkwGAYJKoZIhvcNAQkD
// SIG // MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDMw
// SIG // MTMxMDY1MzU2WjAfBgkqhkiG9w0BCQQxEgQQmUnXS7eS
// SIG // tc61IZnBamW3bzANBgkqhkiG9w0BAQEFAASCAQBA1FDQ
// SIG // iZgs2sOvnRLV2JKsWFs6SmU8bZBacL6i/EUmoXR6fc1k
// SIG // p/p3lYpQJCgJ2TUyjn+BqLBC/zSrJSN5/xCXo0vh1/jZ
// SIG // bR+mv6n4aSZHNnbOF9WJFVh2uM3uVNt9aLGGgmNxQuZS
// SIG // 4Vb2IB7j6jFekC74l7+/c8iHwKk5gWJw+qmVIZdgyExo
// SIG // DSdKm/cAv/Jq9VBXV7WlKjfrk3gQ1WTfgj0ROsM/fq+a
// SIG // txVKAFc/dSnJ27zwlBHeCur3NiWAh7QTszlGQjjgfKwd
// SIG // gjitsz4MuwgKBQnyZskYWfwy5GW7+DKBihE7UrLi0TFU
// SIG // nqlWb1llghl5B4uf+HNlj4/85sPb
// SIG // End signature block
