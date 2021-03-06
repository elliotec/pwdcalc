###
Copyright 2012, Kjel Delaey (https://github.com/trimentor/pwdcalc)
https://github.com/trimentor/pwdcalc/blob/master/LICENSE
###
class @Pwdcalc
  constructor: (selector) ->
    @$inputWrapper = $(selector)
    this.bindYapsm()
    this.bindSubmit()

  bindYapsm: ->
    $input = $('input', @$inputWrapper)
    $input.yapsm(dictionary: ->
      dataDictionary = $input.data 'dictionary'
      list = []
      if dataDictionary
        try
          list = eval dataDictionary
      list
    ).keyup (event) =>
      this.calculateStrength event

  bindSubmit: ->
    @$inputWrapper.closest('form').submit (event) =>
      this.trigger 'pwdcalc-submit', event

  calculateStrength: (event) ->
    $input = $('input', @$inputWrapper)

    yapsmInput = 'undefined'
    for el in $input
      if el.complexity
        yapsmInput = el
        break

    pwd = $.trim yapsmInput.value
    strength = yapsmInput.complexity
    requiredChars = $input.data 'minlength'
    i18nStrength = $(".pwdcalc-hint[data-complexity=#{strength}]").html()

    this.trigger 'pwdcalc-keyup-init', event
    this.showStrength strength, i18nStrength, pwd, requiredChars
    this.trigger 'pwdcalc-keyup-complete', event

  showStrength: (strength, i18nStrength, pwd, requiredChars) ->
    $strengthMeter = $('.pwdcalc', @$inputWrapper)
    $score = $('.pwdcalc_simple', @$inputWrapper)
    if not pwd.length or (requiredChars and pwd.length < requiredChars)
      $strengthMeter.hide().empty()
      $score.hide()
    else
      $strengthMeter.show().attr 'data-complexity', strength
      $score.attr('data-strength', strength).show()

      unless $.trim(i18nStrength.length)
        $strengthMeter.html strength
      else
        $strengthMeter.html i18nStrength

  trigger: (eventType, event) ->
    $input = $('input', @$inputWrapper)
    $(document).trigger eventType, [event, $input]

$ ->
  $("li.pwdcalc, div.pwdcalc_simple").each ->
    inputWrapper = new Pwdcalc this
