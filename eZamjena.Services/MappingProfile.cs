using AutoMapper;
using eZamjena.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile(){
            CreateMap<Database.Korisnik,Model.Korisnik>();
            CreateMap<KorisnikInsertRequest, Database.Korisnik>();
            CreateMap<KorisnikUpdateRequest, Database.Korisnik>();
            CreateMap<AdminKorisnikUpdateRequest, Database.Korisnik>().ForMember(dest => dest.LozinkaHash, opt => opt.Ignore())  // Ignoriraj hash lozinke
                .ForMember(dest => dest.LozinkaSalt, opt => opt.Ignore()); ;

            CreateMap<Database.Uloga, Model.Uloga>();

            CreateMap<Database.Proizvod, Model.Proizvod>();
            CreateMap<Database.Kupovina, Model.Kupovina>();
          


            CreateMap<ProizvodUpsertRequest, Database.Proizvod>();
            CreateMap<KupovinaUpsertRequest, Database.Kupovina>();

            CreateMap<Database.KategorijaProizvodum, Model.KategorijaProizvodum>();
            CreateMap<KategorijaProizvodumUpsertRequest, Database.KategorijaProizvodum>();


            CreateMap<Database.StatusProizvodum, Model.StatusProizvodum>();
            CreateMap<StatusProizvodumUpsertRequest, Database.StatusProizvodum>();


            CreateMap<Database.Ocjena, Model.Ocjena>();
            CreateMap<OcjenaUpsertRequest, Database.Ocjena>();

            CreateMap<Database.Razmjena, Model.Razmjena>();
            CreateMap<RazmjenaUpsertRequest, Database.Razmjena>();

            CreateMap<Database.StatusRazmjene, Model.StatusRazmjene>();
            CreateMap<StatusRazmjeneUpsertRequest, Database.StatusRazmjene>();

            CreateMap<Database.Uloga, Model.Uloga>();
            CreateMap<UlogaUpsertRequest, Database.Uloga>();

            CreateMap<Database.Grad, Model.Grad>();
            CreateMap<GradUpsertRequest, Database.Grad>();


        }
    }
}
