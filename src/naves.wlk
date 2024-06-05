class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method acelerar(cuanto) {
		velocidad = 100000.min(velocidad + cuanto)
	}
	method desacelerar(cuanto) {
		velocidad = 0.max(velocidad - cuanto)
	}
	
	method irHaciaElSol(){ direccion = 10 }
	method escaparDelSol(){ direccion = -10	}
	method ponerseParaleloAlSol(){ direccion = 0 }
	
	method acercarseUnPocoAlSol() {
		direccion = 10.min(direccion + 1)
	}
	method alejarseUnPocoDelSol() {
		direccion = -10.max(direccion - 1)
	}
	
	method cargarCombustible(cuanto){combustible += cuanto}
	method descargarCobustible(cuanto){combustible = 0.max(combustible - cuanto)}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() {
		return combustible >= 4000 && velocidad <= 12000 && self.adicionalTranquilidad()
	}
	method adicionalTranquilidad()
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	
	method estaDeRelajo() {return self.estaTranquila() && self.tienePocaActividad()}
	method tienePocaActividad()
}

class NaveBaliza inherits NaveEspacial{
	var colorBaliza = "verde"
	var cambioBaliza = false
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cambioBaliza = true
	}
	
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol() //lookup method
	}
	override method adicionalTranquilidad() {return colorBaliza != "rojo"}

	override method escapar() {self.irHaciaElSol()}
	override method avisar() {self.cambiarColorDeBaliza("rojo")}

	override method tienePocaActividad(){return !cambioBaliza}
}

class NaveDePasajeros inherits NaveEspacial{
	const cantidadDePasajeros
	var racionesDeComida = 0
	var racionesDeBebida = 0
	var comidaServida = 0
	
	method racionesDeComida() = racionesDeComida
	method racionesDeBebida() = racionesDeBebida
	method comidaServida() = comidaServida
	
	method cargarComida(cuanto){racionesDeComida += cuanto}
	method cargarBebida(cuanto){racionesDeBebida += cuanto}
	method descargarComida(cuanto){racionesDeComida = 0.max(racionesDeComida - cuanto)}
	method descargarBebida(cuanto){racionesDeBebida = 0.max(racionesDeBebida - cuanto)}
	
	override method prepararViaje() {
		super()
		self.cargarComida(4 * cantidadDePasajeros)
		self.cargarBebida(6 * cantidadDePasajeros)
		self.acercarseUnPocoAlSol() //lookup method
	}
	override method adicionalTranquilidad() {return true}
	
	method servirComida(cuanto){
		self.descargarComida(cuanto)
		comidaServida += cuanto.min(racionesDeComida)
	}
	
	method servirBebida(cuanto){
		self.descargarBebida(cuanto)
	}
	
	override method escapar() {self.acelerar(velocidad)}
	override method avisar() {
		self.servirComida(cantidadDePasajeros)
		self.servirBebida(cantidadDePasajeros * 2)
	}
	
	override method tienePocaActividad(){return comidaServida < 50}
}

class NaveHospital inherits NaveDePasajeros{
	var quirofanosPreparados = false
	
	method prepararQuirofanos() {quirofanosPreparados = true}
	method noPrepararQuirofanos() {quirofanosPreparados = false}
	
	override method adicionalTranquilidad() {return !quirofanosPreparados}
	
	override method recibirAmenaza() {
		super()
		self.prepararQuirofanos()
	}
}

class NaveDeCombate inherits NaveEspacial{
	var estaVisible = true
	var misilesDesplegados = false
	const mensajes = []
	
	method ponerseVisible() { estaVisible = true }
	method ponerseInvisible() { estaVisible = false }
	method estaInvisible() { return !estaVisible }
	
	method desplegarMisiles() { misilesDesplegados = true }
	method replegarMisiles() { misilesDesplegados = false }
	method misilesDesplegados() { return misilesDesplegados }
	
	method emitirMensaje(mensaje) { mensajes.add(mensaje) }
	method mensajesEmitidos(mensaje) { return mensajes }	
	method primerMensajeEmitido() { return mensajes.first() }
	method ultimoMensajeEmitido() { return mensajes.last() }
	method esEscueta() { return mensajes.all( {m => m.size() <= 30} ) }
	method emitioMensaje(mensaje) { return mensajes.contains(mensaje) }
	
	override method prepararViaje() {
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000) //lookup method
		self.emitirMensaje("Saliendo en misión")
	}
	override method adicionalTranquilidad() {return !misilesDesplegados}

	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method tienePocaActividad() {return self.esEscueta()}
}

class NaveSigilosa inherits NaveDeCombate{
	override method adicionalTranquilidad() {
		return super() && estaVisible
	}
	
	override method escapar() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}
