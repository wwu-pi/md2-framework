define(["dojo/date/stamp","ct/Exception","ct/_lang"],
    function(stamp,Exception,ct_lang) {
        var fromISOString = stamp.fromISOString;
        var toISOString = stamp.toISOString;
        var u = undefined;
        //msdate e.g.: "\/Date(123456789000+0200)\/"
        var msDate = /^\\?\/Date\((\d+)((?:[-+]\d\d:?\d\d)|Z)?\)\\?\/$/;
        var toDate = function(input, opts){
            opts = opts || {};
            if (input === u || input === null){
                return u;
            }
            if (typeof(input) === 'string'){
                if (msDate.test(input)){
                    var timeparts = msDate.exec(input);
                    return correctTimeZone(new Date(parseInt(timeparts[1])),timeparts[2]);
                }
                if (/^T?\d\d:\d\d.*/.test(input)){
                    if (input.charAt(0)!=="T"){
                        input = "T" + input;
                    }
                    if (opts.noMarkedZulu && (!input.match(/Z$/))){
                        input += "Z";
                    }
                }
                return fromISOString(input);
            }
            if (typeof(input) === 'number'){
                return new Date(input);
            }
            if (input instanceof Date){
                return input;
            }
            throw Exception.illegalArgumentError("expected date input but found <"+input+">");
        }
        var ensureIsoTime = function(input, opts){
            opts = opts || {};
            if (!input){
                return input;
            }
            var zulu = toISOString(toDate(input,opts),{
                selector:opts.selector,
                zulu: ct_lang.chk(opts.zulu||opts.noMarkedZulu, false)
            });
            if (opts.noMarkedZulu){
                zulu = zulu.replace("Z","");
            }
            return zulu;
        }

        var correctTimeZone = function(date, zonepart){
            if (!zonepart){
                return date;
            }
            // zonepart : +01:00 or +0100 or -0100 or Z
            // code is migrated from dojo/date/stamp.js
            var match = /^(?:[+-](\d{2}):?(\d{2}))|Z$/.exec(zonepart);
            var offset = 0,
            zoneSign = match[0].charAt(0);
            if(zoneSign != 'Z'){
                offset = ((match[1] || 0) * 60) + (Number(match[2]) || 0);
                if(zoneSign != '-'){
                    offset *= -1;
                }
            }
            if(zoneSign){
                offset -= date.getTimezoneOffset();
            }
            if(offset){
                date.setTime(date.getTime() + offset * 60000);
            }
            return date;
        }
        return {
            fromISOString : fromISOString,
            toISOString : toISOString,
            toDate : toDate,
            ensureIsoTime : ensureIsoTime
        }
    });