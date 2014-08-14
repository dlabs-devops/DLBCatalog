
var fauxpas = {
    enableLinks: function() {
        if (!('fauxPasNativeApp' in window))
            return;

        var linkifiableCodeTags = [
            'cfunction','objcmethod','objcclass','objccategory',
            'objcproperty','objcprotocol','filename','filepath','resourcepath',
            'docs','cmacro','typedef'
            ];

        $(linkifiableCodeTags.join(',')).each(function(i,n)
        {
            var $obj = $(n);
            $obj.css({'border-bottom':'1px dotted #555', 'cursor':'pointer'});

            var tagname = $obj.prop('tagName').toLowerCase();
            var tooltip = null;
            if (tagname === 'objcproperty')
                tooltip = 'Objective-C property';
            else if (tagname === 'objcclass')
                tooltip = 'Objective-C class';
            else if (tagname === 'objcmethod')
                tooltip = 'Objective-C method';
            else if (tagname === 'objccategory')
                tooltip = 'Objective-C category';
            else if (tagname === 'objcprotocol')
                tooltip = 'Objective-C protocol';
            else if (tagname === 'cfunction')
                tooltip = 'C function';
            else if (tagname === 'cmacro')
                tooltip = 'C macro';
            else if (tagname === 'typedef')
                tooltip = 'Typedef';
            if (!!tooltip)
                $obj.attr('title', tooltip);

            $obj.click(function() {
                var $this = $(this);
                var content = $this.data('content') || $this.text() || null;
                var ref = $this.data('ref') || null;
                var line = $this.data('line') || 0;
                var column = $this.data('column') || 0;

                fauxPasNativeApp.openLink_ofType_ref_line_column_(content, tagname, ref, line, column);
            });
        });
    },
    enableTooltipsForAnchors: function() {
        $('a').each(function(i, el){
            var $el = $(el);
            if (!!$(el).attr('title'))
                return;
            $(el).attr('title', $(this).attr('href'));
        });
    },
    setIcons: function() {
        var $b = $('body.diagnosticsinfo');
        if (!$b)
            return;
        var imgRoot = ''; // '../app/gfx/';
        var impactImageURL = imgRoot+'impact_'+$b.data('impact')+'@2x.png';
        var severityImageURL = imgRoot+'severity_'+$b.data('severity')+'@2x.png';
        var confidenceImageURL = imgRoot+'confidence_'+$b.data('confidence')+'@2x.png';
        $b.find('.heading')
            .css('background-image',
                'url("'+impactImageURL+'"), '+
                'url("'+severityImageURL+'")');
        $b.find('.meta-info span.impact')
            .css('background-image', 'url("'+impactImageURL+'")');
        $b.find('.meta-info span.confidence')
            .css('background-image', 'url("'+confidenceImageURL+'")');
    },
    polyfillTabSize: function() {
        var dummyElement = document.createElement('i');
        var supportsTabSize = (dummyElement.style.tabSize === '');
        if (supportsTabSize)
            return;
        var tabSizeForElement = function($e) {
            var parts = $e.attr('style').split(';');
            for (var i in parts) {
                var item = parts[i];
                if (item.substr(0,9) !== 'tab-size:')
                    continue;
                return parseInt(item.substr(9), 10);
            }
            return undefined;
        };
        var repeat = function(st, n) {
            var s = "";
            while (--n >= 0) { s += st; }
            return s;
        };
        $('.snippet > .content').each(function(i,e){
            var tabSize = tabSizeForElement($(e)) || 4;
            e.innerHTML = e.innerHTML.replace(/\t/g, repeat(" ", tabSize));
        });
    },
    enableActionButtons: function() {
        $('button.action-button').each(function(i,e){
            var $e = $(e);
            $e.click(function(){
                fauxPasNativeApp.invokeGenericAction_withParameter_($e.data('action'), $e.data('param'));
            });
        });
    }
};


$(function() {
    fauxpas.enableTooltipsForAnchors();
    fauxpas.setIcons();
    fauxpas.polyfillTabSize();
    fauxpas.enableActionButtons();
    if ($('body').hasClass('enablelinks'))
        fauxpas.enableLinks();
});
