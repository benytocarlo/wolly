#coding: utf-8

module ApplicationHelper
  def regions_of_chile 
    @regiones = []
    @regiones << 'XV de Arica y Parinacota'
    @regiones << 'I de Tarapacá'
    @regiones << 'II de Antofagasta'
    @regiones << 'III de Atacama'
    @regiones << 'IV de Coquimbo'
    @regiones << 'V de Valparaíso'
    @regiones << "VI del Libertador General Bernardo O'Higgins"
    @regiones << 'VII del Maule'
    @regiones << 'VIII del Biobío'
    @regiones << 'IX de la Araucanía'
    @regiones << 'XIV de los Ríos'
    @regiones << 'X de los Lagos'
    @regiones << 'XI Aysén del General Carlos Ibáñez del Campo'
    @regiones << 'XII de Magallanes y Antártica Chilena'
    @regiones << 'Metropolitana de Santiago'    
    return @regiones
  end
  
  def communes_of region
    if region == 'XV de Arica y Parinacota' then
      return ['Arica', 'Camarones', 'Putre', 'General Lagos']
    end
    if region == 'I de Tarapacá' then
      return ['Alto Hospicio', 'Iquique', 'Huara', 'Camiña', 'Colchane', 'Pica', 'Pozo Almonte']
    end
    if region == 'II de Antofagasta' then
      return ['Tocopilla','María Elena','Calama','Ollagüe','San Pedro de Atacama','Antofagasta','Mejillones','Sierra Gorda','Taltal']
    end
    if region == 'III de Atacama' then
      return ['Chañaral','Diego de Almagro','Copiapó','Caldera','Tierra Amarilla','Vallenar','Freirina','Huasco','Alto del Carmen']
    end
    if region == 'IV de Coquimbo' then
      return ['La Serena','La Higuera','Coquimbo','Andacollo','Vicuña','Paihuano','Ovalle','Río Hurtado','Monte Patria','Cambarbaá','Punitaqui','Illapel','Salamanca','Los Vilos','Canela']
    end
    if region == 'V de Valparaíso' then
      return ['La Ligua','Petrorca','Cabildo','Zapallar','Papudo','Los Andes','San Esteban','Calle Larga','Rinconada','San Felipe','Putaendo','Santa María','Panquehue','Llayllay','Catemu','Quillota','La Cruz','Calera','Nogales','Hijuelas','Limache','Olmué','Valparaíso','Viña del Mar','Quintero','Puchuncaví','Quilpué','Villa Alemana','Casablanca','Concón','Juan Fernández','San Antonio','Cartagena','El Tabo','El Quisco','Algarrobo','Santo Domingo','Isla de Pascua']
    end
    if region == "VI del Libertador General Bernardo O'Higgins" then
      return ['Rancagua','Graneros','Mostazal','Codegua','Machalí','Olivar','Requinoa','Rengo','Malloa','Quinta de Tilcoco','San Vicente','Pichidegua','Peumo','Coltauco','Coinco','Doñihue','Las Cabras','San Fernando','Chimbarongo','Placilla','Nancagua','Chépica','Santa Cruz','Lolol','Pumanque','Palmilla','Peralillo','Pichilemu','Navidad','Litueche','La Estrella','Marchigue','Paredones']
    end
    if region == 'VII del Maule' then
      return ['Curicó','Teno','Romeral','Molina','Sagrada Familia','Hualañé','Licantén','Vichuquén','Rauco','Talca','Pelarco','Río Claro','San Clemente','Maule','San Rafael','Empedrado','Pencahue','Constitución','Curepto','Linares','Yerbas Buenas','Colbún','Longaví','Parral','Retiro','Villa Alegre','San Javier','Cauquenes','Pelluhue','Chanco']
    end
    if region == 'VIII del Biobío' then
      return ['Chillán','San Carlos','Ñiquén','San Fabián','Coihueco','Pinto','San Ignacio','El Carmen','Yungay','Pemuco','Bulnes','Quillón','Ranquil','Portezuelo','Coelemu','Treguaco','Cobquecura','Quirihue','Ninhue','San Nicolás','Chillan Viejo','Alto Biobío','Los Angeles','Cabrero','Tucapel','Antuco','Quilleco','Santa Bárbara','Quilaco','Mulchén','Negrete','Nacimiento','Laja','San Rosendo','Yumbel','Concepción','Talcahuano','Penco','Tomé','Florida','Hualpén','Hualquil','Santa Juana','Lota','Coronel','San Pedro de la Paz','Chiguayente','Lebu','Arauco','Curanilahue','Los Alamos','Cañete','Contulmo','Tirua']
    end
    if region == 'IX de la Araucanía' then
      return ['Angol','Renalco','Collipulli','Lonquimay','Curacautín','Ercilla','Victoria','Traiguén','Lumaco','Purén','Los Sauces','Temuco','Lautaro','Perquenco','Vilcún','Cholchol','Cunco','Melipeuco','Curarrehue','Pucón','Villarrica','Freire','Pitrufquén','Gorbea','Loncoche','Toltén','Teodoro Schmidt','Saavedra','Carahue','Nueva Imperial','Galvarino','Padre las Casas']
    end
    if region == 'XIV de los Ríos' then
      return ['Valdivia','Mariquina','Lanco','Máfil','Corral','Los Lagos','Pnaguipulli','Paillaco','La Unión','Futrono','Río Bueno','Lago Ranco']
    end
    if region == 'X de los Lagos' then
      return ['Osorno','San Pablo','Puyehue','Puerto Octay','Purranque','Río Negro','San Juan de la Costa','Puerto Montt','Puerto Varas','Cochamó','Calbuco','Maullín','Los Muermos','Fresia','Llanquihue','Frutillar','Castro','Ancud','Quemchi','Dalcahue','Curaco de Vélez','Quinchao','Puquedón','Chonchi','Quellén','Quellón','Chaitén','Hualaihue','Futaleufú','Palena']
    end
    if region == 'XI Aysén del General Carlos Ibáñez del Campo' then
      return ['Coyhaique','Lago Verde','Aisén','Cisnes','Guaitecas','Chile Chico','Río Ibáñez','Cochrane',"O´Higgins",'Tortel']
    end
    if region == 'XII de Magallanes y Antártica Chilena' then
      return ['Natales','Torres del Paine','Punta Arenas','Río Verde','Laguna Blanca','San Gregorio','Porvenir','Primavera','Timaukel','Cabo de Hornos','Antártica']
    end
    if region == 'Metropolitana de Santiago' then
      return ['Santiago','Independencia','Conchalí','Huechuraba','Recoleta','Providencia','Vitacura','Lo Barnechea','Las Condes','Ñuñoa','La Reina','Macul','Peñalolén','La Florida','San Joaquín','La Granja','La Pintana','San Ramón','San Miguel','La Cisterna','El Bosque','Pedro Aguirre Cerda','Lo Espejo','Estación Central','Cerrillos','Maipú','Quinta Normal','Lo Prado','Pudahuel','Cerro Navia','Renca','Quilicura','Colina','Lampa','Tiltil','Puente Alto','San José de Maipo','Pirque','San Bernardo','Buin','Paine','Calera de Tango','Melipilla','María Pinto','Curacaví','Alhué','San Pedro','Talagante','Peñaflor','Isla de Maipo','El Monte','Padre Hurtado']
    end
  end
end
